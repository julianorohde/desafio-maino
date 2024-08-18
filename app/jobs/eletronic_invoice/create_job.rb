# frozen_string_literal: true

class EletronicInvoice::CreateJob
  include Sidekiq::Job

  sidekiq_options queue: 'reports'

  def perform(file_path, user_id)
    EletronicInvoice::CreateService.call(file_path:, user_id:)
  end
end
