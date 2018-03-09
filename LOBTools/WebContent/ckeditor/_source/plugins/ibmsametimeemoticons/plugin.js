/* Copyright IBM Corp. 2010-2014 All Rights Reserved.                    */

CKEDITOR.plugins.add( 'ibmsametimeemoticons',
{
	lang: 'af,ar,bg,bn,bs,ca,cs,cy,da,de,el,en-au,en-ca,en-gb,en,eo,es,et,eu,fa,fi,fo,fr-ca,fr,gl,gu,he,hi,hr,hu,is,it,ja,ka,km,ko,lt,lv,mk,mn,ms,nb,nl,no,pl,pt-br,pt,ro,ru,sk,sl,sr-latn,sr,sv,th,tr,ug,uk,vi,zh-cn,zh',
	init : function( editor )
	{
      	   editor.config.smiley_path = editor.config.smiley_path || ( this.path + 'images/' );
 			
           editor.config.smiley_images = [
              'EmoticonHappy.gif',
              'EmoticonLaugh.gif',
              'EmoticonWink.gif',
              'EmoticonBigSmile.gif',
              'EmoticonCool.gif',
              'EmoticonAngry.gif',
              'EmoticonConfused.gif',
              'EmoticonEyebrow.gif',
              'EmoticonSad.gif',
              'EmoticonShy.gif',
              'EmoticonGoofy.gif',
              'EmoticonSurprised.gif',
              'EmoticonTongue.gif',
              'EmoticonLightbulb.gif',
              'EmoticonThumbsUp.gif',
              'EmoticonThumbsDown.gif',
              'EmoticonAngel.gif',
              'EmoticonCrying.gif',
              'EmoticonHysterical.gif'
           ];
	   
			var lang = editor.lang.ibmsametimeemoticons;
           editor.config.smiley_descriptions = [
				lang.smile,
				lang.laughing,
				lang.wink,
				lang.grin,
				lang.cool,
				lang.angry,
				lang.half,
				lang.eyebrow,
				lang.frown,
				lang.shy,
				lang.goofy,
				lang.oops,
				lang.tongue,
				lang.idea,
				lang.yes,
				lang.no,
				lang.angel,
				lang.crying,
				lang.laughroll
           ];
	}
} );
