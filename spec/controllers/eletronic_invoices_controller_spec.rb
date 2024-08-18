# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EletronicInvoicesController, type: :controller do
  let!(:user) { create(:user) }
  let!(:eletronic_invoice) { create(:eletronic_invoice, user:, n_nf: '00001') }
  let!(:product) { create(:product, eletronic_invoice:) }
  let!(:eletronic_invoice2) { create(:eletronic_invoice, user:, n_nf: '00002') }
  let!(:product2) { create(:product, eletronic_invoice: eletronic_invoice2) }
  let(:xml_file) { fixture_file_upload('eletronic_invoice_example.xml', 'application/xml') }
  let(:invalid_file) { fixture_file_upload('invalid_eletronic_invoice_example.txt', 'text/plain') }

  before do
    sign_in user
  end

  describe 'GET #index' do
    context 'when query parameter is present' do
      before { create(:eletronic_invoice, user: create(:user)) }

      it 'returns a filtered list of electronic invoices for the current user' do
        get :index, params: { query: '00001' }

        expect(assigns(:eletronic_invoices)).to match_array([eletronic_invoice])
      end
    end

    context 'when query parameter is not present' do
      before { create(:eletronic_invoice, user: create(:user)) }

      it 'returns all electronic invoices for the current user' do
        get :index

        expect(assigns(:eletronic_invoices)).to match_array([eletronic_invoice, eletronic_invoice2])
      end
    end
  end

  describe 'POST #create' do
    context 'with valid file' do
      it 'enqueues an EletronicInvoice::CreateJob' do
        expect(EletronicInvoice::CreateJob).to receive(:perform_async)

        post :create, params: { file: xml_file }
      end

      it 'redirects to root_path with a success alert' do
        post :create, params: { file: xml_file }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Seu XML será processado e exibido em breve.')
      end
    end

    context 'with invalid file' do
      it 'renders the new template with an error message' do
        post :create, params: { file: invalid_file }
        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq('O formato enviado não é válido, envie arquivos no formato .xml ou .zip')
      end
    end

    context 'without file' do
      it 'renders the new template with an error message' do
        post :create, params: { file: nil }
        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq('Você deve selecionar um arquivo para ser enviado')
      end
    end
  end

  describe 'GET #export' do
    let(:temp_file) { Tempfile.new(['report', '.xls']) }
    let(:filename) { 'relatorio_nota_fiscal_00001.xls' }

    before do
      allow(EletronicInvoice::ExportService).to receive(:call).and_return(temp_file.path)
    end

    after do
      temp_file.close
      temp_file.unlink
    end

    it 'sends the file as an attachment' do
      get :export, params: { id: eletronic_invoice.id }

      content_disposition = response.headers['Content-Disposition']
      expect(content_disposition).to include("attachment; filename=\"#{filename}\"")
      expect(content_disposition).to include("filename*=UTF-8''#{filename}")
      expect(response.body).to eq(File.read(temp_file.path))
    end
  end
end
