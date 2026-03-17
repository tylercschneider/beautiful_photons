module BeautifulPhotons
  class StandalonePhotosController < ApplicationController
    def show
      @standalone = Standalone.find_by!(key: params[:key])
      @photo = @standalone.photo

      if @photo&.image&.attached?
        if stale?(etag: [ @standalone, @photo ], last_modified: [ @standalone.updated_at, @photo.updated_at ].max)
          expires_in 1.year, public: true
        end
      else
        head :no_content
      end
    end
  end
end
