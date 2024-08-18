# frozen_string_literal: true

require 'rails_helper'
require 'caxlsx'

RSpec.describe EletronicInvoice::ExportService, type: :service do
  let!(:eletronic_invoice) { create(:eletronic_invoice) }
  let!(:product) { create(:product, eletronic_invoice:) }
  let!(:service) { described_class.new(eletronic_invoice:) }

  describe '.call' do
    it 'creates a new instance and calls the instance method call' do
      service_instance = instance_double(described_class)

      expect(described_class).to receive(:new).with(eletronic_invoice:).and_return(service_instance)
      expect(service_instance).to receive(:call)

      described_class.call(eletronic_invoice:)
    end
  end

  describe '#initialize' do
    it 'initializes with an eletronic_invoice' do
      expect(service.instance_variable_get(:@eletronic_invoice)).to eq(eletronic_invoice)
    end
  end

  describe '#call' do
    it 'creates an XLSX file and returns the report path' do
      allow(service).to receive(:add_header_row)
      allow(service).to receive(:add_data_rows)

      report_path = service.call

      expect(report_path).to match(%r{tmp/report_\d+\.xlsx})
      expect(File).to exist(report_path)

      # Limpa o arquivo após o teste
      File.delete(report_path) if File.exist?(report_path)
    end

    it 'calls add_header_row and add_data_rows' do
      expect(service).to receive(:add_header_row).once
      expect(service).to receive(:add_data_rows).with(anything, eletronic_invoice).once

      service.call
    end
  end

  describe '#add_header_row' do
    it 'adds header row to the sheet' do
      sheet = instance_double(Axlsx::Worksheet)
      expect(sheet).to receive(:add_row).with(service.send(:eletronic_invoices_columns).merge(service.send(:product_columns)).values)

      service.send(:add_header_row, sheet)
    end
  end

  describe '#add_data_rows' do
    let!(:product) { create(:product, eletronic_invoice:) }
    let!(:product_with_nil_value) { create(:product, eletronic_invoice:, cfop: nil) }

    it 'adds data rows to the sheet' do
      sheet = instance_double(Axlsx::Worksheet)
      expect(sheet).to receive(:add_row).exactly(eletronic_invoice.products.count).times

      service.send(:add_data_rows, sheet, eletronic_invoice)
    end
  end

  describe '#eletronic_invoices_columns' do
    it 'returns eletronic invoice columns' do
      expected_columns = {
        serie: 'Número de Série',
        n_nf: 'Número da Nota Fiscal',
        dh_emi: 'Data e Hora de Emissão',
        emit: 'Dados do Emitente',
        dest: 'Dados do Destinatário'
      }
      expect(service.send(:eletronic_invoices_columns)).to eq(expected_columns)
    end
  end

  describe '#product_columns' do
    it 'returns product columns' do
      expected_columns = {
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
      expect(service.send(:product_columns)).to eq(expected_columns)
    end
  end

  describe '#format_datetime' do
    it 'formats datetime correctly' do
      date = DateTime.new(2024, 8, 18, 12, 34, 56)
      formatted_date = service.send(:format_datetime, date)
      expect(formatted_date).to eq('18/08/2024 12:34:56')
    end
  end
end
