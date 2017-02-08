class CollectionsController < ApplicationController
 

    def index
  	   @collection     = Collection.all
       @collectionrec  = Collection.new
  		
    end

    def show
        
    end

    def new
          # abort(params.to_json)
          gallery_id              = params[:collection][:gallery_id].present? ?  params[:collection][:gallery_id] : 0
          title                   = params[:collection][:title].strip 
          is_collection_exist     = Collection.where(title: title)

          if title==''
             result = {'res' => 0, 'message' => 'Title cannot be blank.'}

          elsif is_collection_exist.present?
              result = {'res' => 0, 'message' => 'Title already exist.'}
             # render json: {'res' => 0, 'message' => 'Title already exist.'}, status: 200
          else
              Collection.create(gallery_id: gallery_id, title: title)
              result = {'res' => 1, 'message' => 'Post has successfully added to collection.'}
              #flash[:notice] = 'Post has successfully added to collection.'
             # redirect_to request.referer

          end 
        render json: result, status: 200
      #redirect_to request.referer
         
    end  

    def show
        #abort(params.to_json)
        collection_id = params[:paramlink]
        @collection = Collection.find(collection_id)    
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

    
end
