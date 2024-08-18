# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe 'Devise permitted parameters' do
    before do
      allow(controller).to receive(:devise_controller?).and_return(true)
    end

    it 'permits the correct parameters for sign_up' do
      sanitizer = double('Devise::ParameterSanitizer')

      expect(controller).to receive(:devise_parameter_sanitizer).and_return(sanitizer)
      expect(sanitizer).to receive(:permit).with(:sign_up, keys: %i[name cpf email password password_confirmation])

      controller.send(:configure_permitted_parameters)
    end
  end
end
