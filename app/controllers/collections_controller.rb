class CollectionsController < ApplicationController
   before_action :authenticate_user!, only: [:new, :show, :update_collection, :index, :create, :edit, :update, :get_gallery_post_list, :count_user_gallery_post]

    def index
  	   @collection     = Collection.all.page(params[:page]).per(10)
       @collectionrec  = Collection.new
  		
    end

    def add_collection
      download_id       = params[:download_id].present? ?  params[:download_id] : 0
      tutorial_id       = params[:tutorial_id].present? ?  params[:tutorial_id] : 0
      collectionrec_id  = params[:collection_id].present? ?  params[:collection_id] : 0 
      gallery_id       = params[:gallery_id].present? ?  params[:gallery_id] : 0
      
      #download
      if(download_id != 0 && collectionrec_id != 0)
          findCollectionDetails=CollectionDetail.where("download_id = ? and collection_id = ?", download_id,collectionrec_id).first
          
          if(findCollectionDetails)
          result = {'res' => 0, 'message' => 'already added to this book marks.'}

          else
            CollectionDetail.create(download_id: download_id, collection_id: collectionrec_id)
           result = {'res' => 1, 'message' => 'added to collection.'}
         end
      end

      #tutorial
      if(tutorial_id != 0 && collectionrec_id != 0)
          findCollectionDetails=CollectionDetail.where("tutorial_id = ? and collection_id = ?", tutorial_id,collectionrec_id).first
          
          if(findCollectionDetails)
          result = {'res' => 0, 'message' => 'already added to this book marks.'}

          else
            CollectionDetail.create(tutorial_id: tutorial_id, collection_id: collectionrec_id)
           result = {'res' => 1, 'message' => 'added to collection.'}
         end
      end

      #gallery
      if(gallery_id != 0 && collectionrec_id != 0)
          findCollectionDetails=CollectionDetail.where("gallery_id = ? and collection_id = ?", gallery_id,collectionrec_id).first
          
          if(findCollectionDetails)
          result = {'res' => 0, 'message' => 'already added to this book marks.'}

          else
            CollectionDetail.create(gallery_id: gallery_id, collection_id: collectionrec_id)
           result = {'res' => 1, 'message' => 'added to collection.'}
         end
      end

      render json: result, status: 200
    end

   
    def new
          #abort(params.to_json)
          gallery_id                = params[:collection][:gallery_id].present? ?  params[:collection][:gallery_id] : 0
          download_id               = params[:collection][:download_id].present? ?  params[:collection][:download_id] : 0
          tutorial_id               = params[:collection][:tutorial_id].present? ?  params[:collection][:tutorial_id] : 0
          title                     = params[:collection][:title].strip 
          is_collection_exist       = Collection.where(title: title)

          if title==''
             result = {'res' => 0, 'message' => 'Title cannot be blank.'}

          elsif is_collection_exist.present?
              result = {'res' => 0, 'message' => 'Title already exist.'}
             # render json: {'res' => 0, 'message' => 'Title already exist.'}, status: 200
          else
              if gallery_id.present?
                collectionrec = Collection.create(gallery_id: 0, title: title, user_id: current_user.id)
              elsif download_id.present?
                  collectionrec = Collection.create(download_id: 0, title: title, user_id: current_user.id)
              elsif tutorial_id.present?
                  collectionrec = Collection.create(tutorial_id: 0, title: title, user_id: current_user.id)             
              end

              if gallery_id != 0
                  CollectionDetail.create(gallery_id: gallery_id, collection_id: collectionrec.id)
              elsif download_id != 0
                  CollectionDetail.create(download_id: download_id, collection_id: collectionrec.id)
              elsif tutorial_id != 0
                  CollectionDetail.create(tutorial_id: tutorial_id, collection_id: collectionrec.id)
              elsif news_id != 0
                  CollectionDetail.create(news_id: news_id, collection_id: collectionrec.id)
              end     
              result = {'res' => 1, 'message' => 'Post has successfully added to bookmark.'}
              #flash[:notice] = 'Post has successfully added to collection.'
             # redirect_to request.referer

          end 
        render json: result, status: 200
      #redirect_to request.referer
          
    end  

    def show 
        #abort(params.to_json)        
        collection_id     = params[:paramlink]
        #abort(collection_id.to_json)
        @collection       = Collection.find(collection_id)        
        @collectiondetail = CollectionDetail.where(collection_id: collection_id).page(params[:page]).per(10)
        #abort(@collectiondetail.to_json)
       # abort(@collectiondetail.to_json)
       
   end  

   def update_collection
    #  abort(params[:collection][:gallery_id].to_json)

      collection_id             = params[:collection][:collection_id]
      collectiontitle           = params[:collection][:title]
     
      @collectionrec            = Collection.where(id: collection_id).first 
      @collectionrec.update(:title => collectiontitle)
      render json: {'res' => 1}, status: 200

   end


    def collectiondelete
      
        @collectiondetail = Collection.find(params[:format])
        if  @collectiondetail.present?
            @collectiondetail.destroy
        end
        redirect_to index_collection_path
    end

   def get_all_collection
     
      #  @collection     = Collection.all
      #render json: {'result' => @collection}, status: 200
   end

    
end
