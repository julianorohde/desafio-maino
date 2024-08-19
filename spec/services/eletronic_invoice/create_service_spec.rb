# frozen_string_literal: true

require 'rails_helper'
require 'nokogiri'
require 'zip'
require 'caxlsx'

RSpec.describe EletronicInvoice::CreateService, type: :service do
  let(:user) { create(:user) }
  let(:xml_file_path) { Rails.root.join('spec', 'fixtures', 'files', 'eletronic_invoice_example.xml').to_s }
  let(:zip_file_path) { Rails.root.join('spec', 'fixtures', 'files', 'eletronic_invoice_example.zip').to_s }
  let(:invalid_file_path) { Rails.root.join('spec', 'fixtures', 'files', 'invalid_file.txt').to_s }

  describe '.call' do
    it 'creates a new instance and calls the instance method call' do
      service_instance = instance_double(described_class)

      expect(described_class).to receive(:new).with(file_path: xml_file_path, user_id: user.id).and_return(service_instance)
      expect(service_instance).to receive(:call)

      described_class.call(file_path: xml_file_path, user_id: user.id)
    end
  end
end
