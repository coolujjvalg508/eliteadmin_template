class ZipFile < ActiveRecord::Base
mount_uploader :zipfile, FileUploader
attr_accessor :tmp_zipfile
end
