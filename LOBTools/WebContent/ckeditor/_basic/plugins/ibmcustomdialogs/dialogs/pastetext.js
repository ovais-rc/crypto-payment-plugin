﻿CKEDITOR.tools.extend(CKEDITOR.ibm.dialogs,{pastetext:function(b,c){if("pastetext"===b.dialog.getName()){var d=b.getContents("general"),a=d.get("content");a.onLoad=function(){this.getElement().setStyle("direction",c.config.contentsLangDirection)};a.label=c.lang.clipboard.pasteMsg;d.elements=[a]}}},!0);