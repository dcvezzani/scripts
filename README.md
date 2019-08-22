# Scripts

I have several scripts that I make use of when I develop code.  This document provides some information on how to use them.

## LDS Publisher Tools

Generate boiler plate form.xml and transform.xqy files for LDS Publisher

### New Form

Usage
```
/Users/dcvezzani/scripts/pb-generate-form.sh <name> <display> <attr-value,attr-text:attr-type> ...
```

Supported `attr-type`
* text|string
* dlist/close-dlist
* image

Examples
```
/Users/dcvezzani/scripts/pb-generate-form.sh 'mlp-hero-search' 'MLP Hero Search' 'title,Title:text' 'image,Image:image'

/Users/dcvezzani/scripts/pb-generate-form.sh \
mlp-spot-link 'MLP Spot Link' 'title,Title:text:*' 'description,Description:text' 'link,Link:text'

/Users/dcvezzani/scripts/pb-generate-form.sh \
mlp-spot-link-block 'MLP Spot Link Block' 'spotLinks,Spot Links:dlist' 'title,Title:text:*' 'description,Description:text' 'link,Link:text'

/Users/dcvezzani/scripts/pb-generate-form.sh \
vertical-tiles 'Veritical Tiles' 'items,Vertical Tile Items:dlist' title,Title:text:* pretitle,Pre-Title:text description,Description:text href,Href:text:* image,Image:image 'mediaAspectRatio,Media Aspect Ratio:text'

/Users/dcvezzani/scripts/pb-generate-form.sh \
horizontal-tiles 'Horizontal Tiles' 'items,Horizontal Tile Items:dlist' title,Title:text:* pretitle,Pre-Title:text description,Description:text href:Href:text:* image,Image:image

/Users/dcvezzani/scripts/pb-generate-form.sh \
drawer 'Drawer' 'drawerLabel,Drawer Label:text:*' 'components,Components:dlist' 'componentName,Component Name:text:*' 'contactCards,Contact Cards:dlist' name,Name:text:* title,Title:text phone,Phone:text email,Email:text
```

### New Transform

Usage
```
/Users/dcvezzani/scripts/pb-generate-form.sh <name> <attr-value,attr-path:attr-type> ...
```

Supported `attr-type`
* url
* text|string
* image
* array/close-array

Notes
* Do not append '-template' to the end of the transform name.  It will be added for you as a convention.

Examples
```
/Users/dcvezzani/scripts/pb-generate-transform.sh 'vertical-tiles'
/Users/dcvezzani/scripts/pb-generate-transform.sh 'vertical-tiles' items:array href:url title:string description:string pretitle:string mediaAspectRatio:string image:image items:close-array
/Users/dcvezzani/scripts/pb-generate-transform.sh 'vertical-tiles' items,stuff/items-item:array href:url title:string description:string pretitle:string mediaAspectRatio:string image:image items:close-array
```
