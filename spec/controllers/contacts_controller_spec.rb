require 'rails_helper'

describe ContactsController do

  describe 'GET #index' do
    #params[:letter]がある場合
    context 'with params[:letter]' do
      #指定された文字で始まる連絡先を配列にまとめること
      it "populates an array of contacts starting with the letter" do
        smith = create(:contact, lastname: 'Smith')
        jones = create(:contact, lastname: 'Jones')
        get :index, letter: 'S'
        expect(assigns(:contacts)).to match_array([smith])
      end

      #:indexテンプレートを表示すること
      it "renders the :index template" do
        get :index, letter: 'S'
        expect(response).to render_template :index
      end
    end

    #params[:letter]がない場合
    context 'without params[:letter]' do
      #全ての連絡先を配列にまとめること
      it "populates an array of all contacts" do
        smith = create(:contact, lastname: 'Smith')
        jones = create(:contact, lastname: 'Jones')
        get :index
        expect(assigns(:contacts)).to match_array([smith, jones])
      end
      #:indexテンプレートを表示すること
      it "renders the :index template" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET #show' do
    #@contactに要求された連絡先を割り当てること
    it "assigns the requested contact to @contact" do
      contact = create(:contact)
      get :show, id: contact
      expect(assigns(:contact)).to eq contact
    end

    #:showテンプレートを表示すること
    it "renders the :show template" do
      contact = create(:contact)
      get :show, id: contact
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    #@contactに新しい連絡先を割り当てること
    it "assigns a new Contact to @contact" do
      get :new
      expect(assigns(:contact)).to be_a_new(Contact)
    end
    #:newテンプレートを表示すること
    it "renders the :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    #@contactに要求された連絡先を割り当てること
    it "assigns the requested contact to @contact" do
      contact = create(:contact)
      get :edit, id: contact
      expect(assigns(:contact)).to eq contact
    end
    #:editテンプレートを表示すること
    it "renders the :edit template"  do
      contact = create(:contact)
      get :edit, id: contact
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before :each do
      @phones = [
        attributes_for(:phone),
        attributes_for(:phone),
        attributes_for(:phone)
      ]
    end

    #有効な属性の場合
    context "with valid attributes" do
      #データベースに新しい連絡先を保存すること
      it "saves the new contact in the databese" do
        expect{
          post :create, contact: attributes_for(:contact,
            phones_attributes: @phones)
        }.to change(Contact, :count).by(1)
      end

      #contacts#showにリダイレクトすること
      it "redirects to contacts#show" do
        post :create, contact: attributes_for(:contact,
          phones_attributes: @phones)
        expect(response).to redirect_to contact_path(assigns[:contact])
      end
    end

    #無効な属性の場合
    context "with invalid attributes" do
      #データベースに新しい連絡先を保存しないこと
      it "does not save the new contact in the databese" do
        expect{
          post :create,
            contact: attributes_for(:invalid_contact)
        }.not_to change(Contact, :count)
      end

      #:newテンプレートを再表示すること
      it "re-renders the :new template" do
        post :create,
          contact: attributes_for(:invalid_contact)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @contact = create(:contact,
        firstname: 'Lawrence',
        lastname: 'Smith')
    end

    #有効な属性の場合
    context "valid attributes" do
      #要求された@contactを取得すること
      it "locates the requested @contact" do
        patch :update, id: @contact, contact: attributes_for(:contact)
        expect(assigns(:contact)).to eq(@contact)
      end

      #@contactの属性を変更すること
      it "changes @contact's attributes" do
        patch :update, id: @contact, contact: attributes_for(:contact, firstname: 'Larry', lastname: 'Smith')
        @contact.reload
        expect(@contact.firstname).to eq('Larry')
        expect(@contact.lastname).to eq('Smith')
      end

      #更新した連絡先のページへリダイレクトすること
      it "redirects to the updated contact" do
        patch :update, id: @contact, contact: attributes_for(:contact)
        expect(response).to redirect_to @contact
      end
    end

    #無効な属性の場合
    context "with invalid attributes" do
      #連絡先の属性を変更しないこと
      it "does not change the contact's attributes" do
        patch :update, id: @contact, contact: attributes_for(:contact, firstname: "Larry", lastname: nil)
        @contact.reload
        expect(@contact.firstname).not_to eq("Larry")
        expect(@contact.lastname).to eq("Smith")
      end

      #editテンプレートを再表示すること
      it "re-renders the edit template" do
        patch :update, id: @contact, contact: attributes_for(:invalid_contact)
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @contact = create(:contact)
    end

    #連絡先を削除すること
    it "deletes the contact" do
      expect{
        delete :destroy, id: @contact
      }.to change(Contact, :count).by(-1)
    end

    #contacts#indexにリダイレクトすること
    it "redirects to contacts#index" do
      delete :destroy, id: @contact
      expect(response).to redirect_to contacts_url
    end
  end
end
