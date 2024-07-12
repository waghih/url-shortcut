require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:link) { create(:link, short_url: 'abc123') }
  let!(:link_with_visits) { create(:link) }
  let(:valid_attributes) { { original_url: 'http://example.com', title: 'Example' } }
  let(:invalid_attributes) { { original_url: '', title: '' } }

  before do
    allow(LinkShortenerService).to receive(:new).and_call_original
    allow_any_instance_of(LinkShortenerService).to receive(:fetch_title).and_return('Fetched Title')
  end

  describe 'GET #index' do
    it 'assigns @links and @decorated_links' do
      get :index
      expect(assigns(:links)).to eq([link, link_with_visits])
      expect(assigns(:decorated_links).map(&:class)).to all(eq(LinkDecorator))
    end
  end

  describe 'GET #show' do
    it 'assigns @link' do
      get :show, params: { id: link.short_url }
      expect(assigns(:link)).to be_a(LinkDecorator)
    end
  end

  describe 'GET #new' do
    it 'assigns a new link' do
      get :new
      expect(assigns(:link)).to be_a_new(Link)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Link and redirects' do
        expect do
          post :create, params: { link: valid_attributes }
        end.to change(Link, :count).by(1)
        expect(response).to redirect_to(link_path(Link.last.short_url))
      end
    end

    context 'with invalid params' do
      it 'renders the new template with unprocessable_entity status' do
        post :create, params: { link: invalid_attributes }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested link and redirects' do
      link_to_delete = create(:link)
      expect do
        delete :destroy, params: { id: link_to_delete.short_url }
      end.to change(Link, :count).by(-1)
      expect(response).to redirect_to(links_url)
    end
  end

  describe 'GET #redirect' do
    context 'when the link exists' do
      it 'enqueues the RecordVisitWorker and redirects' do
        expect(RecordVisitWorker).to receive(:perform_async).with(link.id, request.location.data)
        get :redirect, params: { short_url: link.short_url }
        expect(response).to redirect_to(link.original_url)
      end
    end

    context 'when the link does not exist' do
      it 'renders plain text with not_found status' do
        get :redirect, params: { short_url: 'notexist' }
        expect(response.body).to eq('URL not found')
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET #fetch_title' do
    it 'fetches the title and returns it as JSON' do
      get :fetch_title, params: { original_url: 'http://example.com' }
      expect(response.parsed_body).to eq('title' => 'Fetched Title')
    end
  end

  describe 'GET #search_stats' do
    context 'when the link exists' do
      it 'redirects to the link path' do
        get :search_stats, params: { short_url: link.short_url }
        expect(response).to redirect_to(link_path(link.short_url))
      end
    end

    context 'when the link does not exist' do
      it 'renders 404' do
        get :search_stats, params: { short_url: 'notexist' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
