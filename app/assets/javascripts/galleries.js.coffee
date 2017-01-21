jQuery ->
  new CarrierWaveCropper()

class CarrierWaveCropper
  constructor: ->
    $('#gallery_company_logo_cropbox').Jcrop
      aspectRatio: 1
      setSelect: [0, 0, 200, 200]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#gallery_company_logo_crop_x').val(coords.x)
    $('#gallery_company_logo_crop_y').val(coords.y)
    $('#gallery_company_logo_crop_w').val(coords.w)
    $('#gallery_company_logo_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    $('#gallery_company_logo_previewbox').css
      width: Math.round(100/coords.w * $('#gallery_company_logo_cropbox').width()) + 'px'
      height: Math.round(100/coords.h * $('#gallery_company_logo_cropbox').height()) + 'px'
      marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'
