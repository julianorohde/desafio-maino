# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EletronicInvoice::CreateJob, type: :job do
  describe '#perform' do
    let(:xml_file) { fixture_file_upload('eletronic_invoice_example.xml', 'application/xml') }
    let(:user) { create(:user) }

    before do
      allow(EletronicInvoice::CreateService).to receive(:call)
    end

    it 'enqueues the job with correct arguments' do
      Sidekiq::Worker.clear_all

      EletronicInvoice::CreateJob.perform_async(xml_file.path, user.id)

      expect(EletronicInvoice::CreateJob).to have_enqueued_sidekiq_job(xml_file.path, user.id)
    end

    it 'calls EletronicInvoice::CreateService with correct arguments' do
      EletronicInvoice::CreateJob.perform_async(xml_file.path, user.id)

      Sidekiq::Worker.drain_all

      expect(EletronicInvoice::CreateService).to have_received(:call).with(file_path: xml_file.path, user_id: user.id)
    end
  end
end
