# frozen_string_literal: true

require 'nokogiri'
require 'zip'
require 'caxlsx'

class EletronicInvoice::CreateService
  def self.call(file_path: nil, user_id: nil)
    new(file_path:, user_id:).call
  end

  def initialize(file_path:, user_id:)
    @file_path = file_path
    @user_id = user_id
  end

  def call
    @report_path = send(handlers[File.extname(file_path).downcase])
  end

  private

  attr_reader :file_path, :user_id

  def s3_client
    @s3_client ||= Aws::S3::Client.new
  end

  def handlers
    {
      '.zip' => :handle_zip_file,
      '.xml' => :handle_xml_file
    }
  end

  def handle_zip_file
    datas = []

    File.open(Rails.root.join("tmp/#{file_path}"), 'wb') do |temp_file|
      temp_file.write(file.body.read)
    end

    Zip::File.open(Rails.root.join("tmp/#{file_path}")) do |zip_file|
      zip_file.each do |entry|
        next unless File.extname(entry.name) == '.xml'

        file_path = Rails.root.join("tmp/#{entry.name}")
        entry.extract(file_path) { true }
        doc = Nokogiri::XML(File.read(file_path))
        data = extract_data(doc)
        datas << data
      end
    end
  end

  def handle_xml_file
    doc = Nokogiri::XML(file.body.read)

    datas = []

    datas << extract_data(doc)
  end

  def file
    @file ||=
      s3_client.get_object(
        bucket: 'default',
        key: file_path
      )
  end

  def extract_data(doc)
    @namespace = 'http://www.portalfiscal.inf.br/nfe'

    eletronic_invoice = user.eletronic_invoices.create(normalize_eletronic_invoice(doc))

    normalize_products(doc).each do |product|
      eletronic_invoice.products.create(product)
    end
  end

  def to_float(value)
    value&.sub(',', '.')&.to_f || 0
  end

  def user
    @user ||= User.find(user_id)
  end

  def format_datetime(datetime_str)
    DateTime.parse(datetime_str).strftime('%d/%m/%Y %H:%M:%S')
  end

  def normalize_eletronic_invoice(doc)
    {
      serie: doc.at_xpath('//nfe:infNFe/nfe:ide/nfe:serie', 'nfe' => @namespace)&.text&.strip.presence || '',
      n_nf: doc.at_xpath('//nfe:infNFe/nfe:ide/nfe:cNF', 'nfe' => @namespace)&.text&.strip.presence || '',
      dh_emi: format_datetime(doc.at_xpath('//nfe:infNFe/nfe:ide/nfe:dhEmi', 'nfe' => @namespace)&.text&.strip.presence) || '',
      emit: doc.at_xpath('//nfe:infNFe/nfe:emit', 'nfe' => @namespace)&.text&.strip.presence || '',
      dest: doc.at_xpath('//nfe:infNFe/nfe:dest', 'nfe' => @namespace)&.text&.strip.presence || ''
    }
  end

  def normalize_products(doc)
    products = []
    doc.xpath('//nfe:infNFe/nfe:det', 'nfe' => @namespace).each do |product|
      products << {
        x_prod: product.at_xpath('nfe:prod/nfe:xProd', 'nfe' => @namespace)&.text&.strip.presence || '',
        ncm: product.at_xpath('nfe:prod/nfe:NCM', 'nfe' => @namespace)&.text&.strip.presence || '',
        cfop: product.at_xpath('nfe:prod/nfe:CFOP', 'nfe' => @namespace)&.text&.strip.presence || '',
        u_com: product.at_xpath('nfe:prod/nfe:uCom', 'nfe' => @namespace)&.text&.strip.presence || '',
        q_com: product.at_xpath('nfe:prod/nfe:qCom', 'nfe' => @namespace)&.text&.strip.presence || '',
        v_un_com: to_float(product.at_xpath('nfe:prod/nfe:vUnCom', 'nfe' => @namespace)&.text),
        v_icms: to_float(product.at_xpath('nfe:imposto/nfe:ICMS/nfe:vICMS', 'nfe' => @namespace)&.text),
        v_ipi: to_float(product.at_xpath('nfe:imposto/nfe:IPI/nfe:vIPI', 'nfe' => @namespace)&.text),
        v_pis: to_float(product.at_xpath('nfe:imposto/nfe:PIS/nfe:vPIS', 'nfe' => @namespace)&.text),
        v_cofins: to_float(product.at_xpath('nfe:imposto/nfe:COFINS/nfe:vCOFINS', 'nfe' => @namespace)&.text)
      }
    end
    products
  end
end
