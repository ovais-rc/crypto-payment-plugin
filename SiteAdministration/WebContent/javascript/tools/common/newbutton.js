//
//-------------------------------------------------------------------
// Licensed Materials - Property of IBM
//
// WebSphere Commerce
//
// (c) Copyright IBM Corp. 2006
//
// US Government Users Restricted Rights - Use, duplication or
// disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
//-------------------------------------------------------------------
//

/**********************************************************************/
/*              Util function for Button                              */
/**********************************************************************/

var Buttons = new Object();

/**********************************************************************/
/* Buttons.button1.value: NLS name of button                          */
/* Buttons.button1.display: if this button shows up                   */
/* Buttons.button1.Class: either enabled or disabled                  */
/**********************************************************************/
function getButtons(){

    var b = '';

    for(attribute in Buttons){
        b += '<tr id="' + attribute + '_tr" ';
        if (!Buttons[attribute].display)
        {
            b += ' style="display: none" ';
        }
        b += ">";
        b += '<td class="button1" valign="middle">';
        b += '<button value="';
        b += Buttons[attribute].value;
        b += '" name="' + attribute + '" ';
        if (Buttons[attribute].Class.toLowerCase() == "disabled")
            b += ' disabled="disabled" ';
 	b += ' class="' + Buttons[attribute].Class + '"'; 
        b += ' onclick="javascript:parent.' + attribute + 'Action();" style="width: 135px;"> ';

        b += '<span class="buttonText">';
        b += Buttons[attribute].value;
        b += "</span>";

        b += "</button>";

        b += "</td>";
        b += "</tr>";
        buttons.document.writeln(b);
        b = '';
    }

}

/* Adjust the button height for mult-language and different font */
function AdjustRefreshButton(butName, classStyle){
	if (butName && classStyle) {
		butName.className = classStyle;
				
		if (classStyle.toLowerCase() == "disabled") {
			butName.disabled = true;
		}
		else {
			butName.disabled = false;
		}
        }
}