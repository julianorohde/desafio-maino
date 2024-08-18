# frozen_string_literal: true

require 'caxlsx'

class EletronicInvoice::ExportService
  def self.call(eletronic_invoice: nil)
    new(eletronic_invoice:).call
  end

  def initialize(eletronic_invoice:)
    @eletronic_invoice = eletronic_invoice
  end

  def call
    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: 'Relatório') do |sheet|
      add_header_row(sheet)
      add_data_rows(sheet, eletronic_invoice)
    end

    @report_path = Rails.root.join('tmp', "report_#{Time.now.to_i}.xlsx").to_s
    package.serialize(@report_path)
    @report_path
  end

  private

  attr_reader :eletronic_invoice

  def eletronic_invoice
    @eletronic_invoice ||= EletronicInvoice.find_by(id: eletronic_invoice)
  end

  def add_header_row(sheet)
    header_columns = eletronic_invoices_columns.merge(product_columns)
    sheet.add_row(header_columns.values)
  end

  def add_data_rows(sheet, eletronic_invoice)
    eletronic_invoice.products.each do |product|
      row = eletronic_invoices_columns.keys.map do |key|
        case key
        when :dh_emi
          format_datetime(eletronic_invoice.send(key))
        else
          eletronic_invoice.send(key)
        end
      end

      row += product_columns.keys.map do |key|
        value = product.send(key)
        case value
        when nil
          ''
        when BigDecimal, Float, Integer
          value.to_s('F')
        else
          value.to_s
        end
      end

      sheet.add_row(row)
    end
  end

  def eletronic_invoices_columns
    {
      serie: 'Número de Série',
      n_nf: 'Número da Nota Fiscal',
      dh_emi: 'Data e Hora de Emissão',
      emit: 'Dados do Emitente',
      dest: 'Dados do Destinatário'
    }
  end

  def product_columns
    {
      x_prod: 'Nome',
      ncm: 'NCM',
      cfop: 'CFOP',
      u_com: 'Unidade Comercializada',
      q_com: 'Quantidade Comercializada',
      v_un_com: 'Valor Unitário',
      v_icms: 'Valor do ICMS',
      v_ipi: 'Valor do IPI',
      v_pis: 'Valor do PIS',
      v_cofins: 'Valor do COFINS'
    }
  end

  def format_datetime(date)
    date.strftime('%d/%m/%Y %H:%M:%S')
  end
end
