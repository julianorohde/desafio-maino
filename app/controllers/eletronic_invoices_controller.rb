# frozen_string_literal: true

require 'aws-sdk'

class EletronicInvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_params, only: %i[create]
  before_action :validate_file, only: %i[create]

  def index
    @eletronic_invoices = if params[:query].present?
                            individual_search
                          else
                            current_user.eletronic_invoices.order(created_at: :desc)
                          end
  end

  def create
    EletronicInvoice::CreateJob.perform_async(upload_file_and_return_name, current_user.id)

    redirect_to root_path, alert: 'Seu XML será processado e exibido em breve.'
  end

  def export
    send_file_to_download(EletronicInvoice::ExportService.call(eletronic_invoice:)) if eletronic_invoice
  end

  private

  attr_reader :file

  def filter
    Arel.sql("%#{params[:query]}%")
  end

  def eletronic_invoice
    @eletronic_invoice ||= current_user.eletronic_invoices.find_by(id: params[:id])
  end

  def set_params
    @file = permitted_params['file']
  end

  def validate_file
    error_message = if file.blank?
                      'Você deve selecionar um arquivo para ser enviado'
                    elsif !['.zip', '.xml'].include?(File.extname(file).downcase)
                      'O formato enviado não é válido, envie arquivos no formato .xml ou .zip'
                    end

    if error_message
      flash.now[:alert] = error_message
      render :new, status: :unprocessable_entity
    end
  end

  def upload_file_and_return_name
    s3_client.put_object(
      key: file.original_filename,
      body: file.read,
      bucket: 'default',
      content_type: file.content_type
    )

    file.original_filename
  end

  def s3_client
    @s3_client ||= Aws::S3::Client.new
  end

  def sanitize_file(file)
    FileUtils.copy(file.path, Rails.root.join('tmp', File.basename(file.path)))

    Rails.root.join('tmp', File.basename(file.path)).to_s
  end

  def send_file_to_download(file_path)
    send_file(
      file_path,
      filename: "relatorio_nota_fiscal_#{eletronic_invoice.n_nf}.xls",
      type: 'application/vnd.ms-excel',
      disposition: 'attachment'
    )
  end

  def individual_search
    current_user.eletronic_invoices
                .joins(:products)
                .where(
                  'n_nf ILIKE ? OR emit ILIKE ? OR dest ILIKE ? OR products.x_prod ILIKE ?',
                  filter, filter, filter, filter
                ).order(created_at: :desc).distinct
  end

  def permitted_params
    params.permit(:file, :authenticity_token, :commit)
  end
end
