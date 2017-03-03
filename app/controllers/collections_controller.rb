class CollectionsController < ApplicationController
 

    def index
  	   @collection     = Collection.all.page(params[:page]).per(10)
       @collectionrec  = Collection.new
  		
    end

   
    def new
          #abort(params.to_json)
          gallery_id              = params[:collection][:gallery_id].present? ?  params[:collection][:gallery_id] : 0
          title                   = params[:collection][:title].strip 
          is_collection_exist     = Collection.where(title: title)

          if title==''
             result = {'res' => 0, 'message' => 'Title cannot be blank.'}

          elsif is_collection_exist.present?
              result = {'res' => 0, 'message' => 'Title already exist.'}
             # render json: {'res' => 0, 'message' => 'Title already exist.'}, status: 200
          else
              collectionrec = Collection.create(gallery_id: 0, title: title)
              if gallery_id != 0
                  CollectionDetail.create(gallery_id: gallery_id, collection_id: collectionrec.id)
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
        @collection       = Collection.find(collection_id)
        @collectiondetail = CollectionDetail.where(collection_id: collection_id).page(params[:page]).per(10)
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
