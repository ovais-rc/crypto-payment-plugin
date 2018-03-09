<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2009, 2015 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>

<%@page contentType="text/xml;charset=UTF-8"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.ibm.icu.text.Collator"%>

<%@ include file="GetTimeZoneDisplayName.jspf"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://commerce.ibm.com/foundation" prefix="wcf" %>

<%!
	class TimeZoneDisplayComparator implements Comparator {
		Locale locale;
		public void setLocale(Locale locale) {
			this.locale = locale;
		}

    	public int compare(Object tid1, Object tid2) {
    		String name1 = TimeZone.getTimeZone((String)tid1).getDisplayName(this.locale);
    		String name2 = TimeZone.getTimeZone((String)tid2).getDisplayName(this.locale);
    		Collator collator = Collator.getInstance(this.locale);
    		return collator.compare(name1, name2);
		}
	}
%>



<%
	String localeStr = request.getParameter("locale");
	Locale locale = null;
	if (localeStr == null) {
		locale = Locale.getDefault();
	}
	else {
		String[] localeInfo = localeStr.split("_");
		if (localeInfo.length == 1) {
			locale = new Locale(localeInfo[0]);
		}
		else{
			locale = new Locale(localeInfo[0], localeInfo[1]);
		}
	}

	String[] timeZoneIds = {
			"Pacific/Midway", //Midway (United States Minor Outlying Islands)(GMT -11)
			"Pacific/Apia", //Samoa(GMT -11)
			"US/Hawaii", //Hawaii Time(GMT -10)
			"US/Alaska", //Alaska Time(GMT -9)
			"Canada/Pacific", //Pacific Time (CA)(GMT -8)
			"America/Tijuana", //Tijuana (Mexico)(GMT -8)
			"US/Pacific", //Pacific Time(GMT -8)
			"Asia/Phnom_Penh", //Cambodia(GMT 7)
			"America/Chihuahua", //Chihuahua (Mexico)(GMT -7)
			"America/Mazatlan", //Mazatlan (Mexico)(GMT -7)
			"US/Mountain", //Mountain Time(GMT -7)
			"Canada/Mountain", //Mountain Time (CA)(GMT -7)
			"America/Belize", //Belize(GMT -6)
			"America/Chicago", //Central Time(GMT -6)
			"America/Winnipeg", //Central Time (CA)(GMT -6)
			"America/Costa_Rica", //Costa Rica(GMT -6)
			"Pacific/Easter", //Easter (Chile)(GMT -6)
			"America/El_Salvador", //El Salvador(GMT -6)
			"Pacific/Galapagos", //Galapagos (Ecuador)(GMT -6)
			"America/Guatemala", //Guatemala(GMT -6)
			"America/Tegucigalpa", //Honduras(GMT -6)
			"America/Mexico_City", //Mexico City (Mexico)(GMT -6)
			"America/Managua", //Nicaragua(GMT -6)
			"America/Regina", //Regina (Canada)(GMT -6)
			"America/Nassau", //Bahamas(GMT -5)
			"America/Cayman", //Cayman Islands(GMT -5)
			"America/Bogota", //Colombia(GMT -5)
			"America/New_York", //Eastern Time(GMT -5)
			"America/Montreal", //Eastern Time (CA)(GMT -5)
			"America/Guayaquil", //Ecuador(GMT -5)
			"America/Port-au-Prince", //Haiti(GMT -5)
			"America/Jamaica", //Jamaica(GMT -5)
			"America/Panama", //Panama(GMT -5)
			"America/Lima", //Peru(GMT -5)
			"America/Grand_Turk", //Turks and Caicos Islands(GMT -5)
			"America/Havana", //Cuba(GMT -5)
			"America/Anguilla", //Anguilla(GMT -4)
			"America/Antigua", //Antigua and Barbuda(GMT -4)
			"America/Aruba", //Aruba(GMT -4)
			"America/Halifax", //Atlantic Time(GMT -4)
			"America/Barbados", //Barbados(GMT -4)
			"Atlantic/Bermuda", //Bermuda(GMT -4)
			"America/La_Paz", //Bolivia(GMT -4)
			"America/Tortola", //British Virgin Islands(GMT -4)
			"America/Santiago", //Chile(GMT -4)
			"America/Dominica", //Dominica(GMT -4)
			"Atlantic/Stanley", //Falkland Islands(GMT -4)
			"America/Grenada", //Grenada(GMT -4)
			"America/Guadeloupe", //Guadeloupe(GMT -4)
			"America/Guyana", //Guyana(GMT -4)
			"America/Manaus", //Manaus (Brazil)(GMT -4)
			"America/Martinique", //Martinique(GMT -4)
			"America/Montserrat", //Montserrat(GMT -4)
			"America/Curacao", //Netherlands Antilles(GMT -4)
			"America/Asuncion", //Paraguay(GMT -4)
			"America/Puerto_Rico", //Puerto Rico(GMT -4)
			"America/St_Kitts", //Saint Kitts and Nevis(GMT -4)
			"America/St_Lucia", //Saint Lucia(GMT -4)
			"America/St_Vincent", //Saint Vincent and the Grenadines(GMT -4)
			"America/Port_of_Spain", //Trinidad and Tobago(GMT -4)
			"America/Virgin", //U.S. Virgin Islands(GMT -4)
			"America/Caracas", //Venezuela(GMT -4)
			"America/Santo_Domingo", //Dominican Republic(GMT -4)
			"America/Cayenne", //French Guiana(GMT -3)
			"America/Godthab", //Greenland(GMT -3)
			"Canada/Newfoundland", //Newfoundland Time(GMT -3)
			"America/Paramaribo", //Suriname(GMT -3)
			"America/Sao_Paulo", //Sao Paulo (Brazil)(GMT -3)
			"America/Buenos_Aires", //Buenos Aires (Argentina)(GMT -3)
			"America/Montevideo", //Uruguay(GMT -3)
			"America/Noronha", //Noronha (Brazil)(GMT -2)
			"Atlantic/South_Georgia", //South Georgia and the South Sandwich Islands(GMT -2)
			"Atlantic/Azores", //Azores (Portugal)(GMT -1)
			"Atlantic/Cape_Verde", //Cape Verde(GMT -1)
			"Atlantic/Reykjavik", //Iceland(GMT 0)
			"Europe/Dublin", //Ireland(GMT 0)
			"Africa/Casablanca", //Morocco(GMT 0)
			"Europe/London", //United Kingdom(GMT 0)
			"Europe/Lisbon", //Portugal(GMT 0)
			"Africa/Douala", //Cameroon(GMT 1)
			"Europe/Amsterdam",//Netherlands(GMT 1)
			"Europe/Andorra",//Andorra(GMT 1)
			"Europe/Belgrade",//Serbia And Montenegro(GMT 1)
			"Europe/Berlin",//Germany(GMT 1)
			"Europe/Bratislava",//Slovakia(GMT 1)
			"Europe/Brussels",//Belgium(GMT 1)
			"Europe/Budapest",//Hungary(GMT 1)
			"Europe/Copenhagen",//Denmark(GMT 1)
			"Europe/Gibraltar",//Gibraltar(GMT 1)
			"Europe/Luxembourg",//Luxembourg(GMT 1)
			"Europe/Madrid",//Spain(GMT 1)
			"Europe/Malta",//Malta(GMT 1)
			"Europe/Oslo",//Norway(GMT 1)
			"Europe/Prague",//Czech Republic(GMT 1)
			"Europe/Rome",//Italy(GMT 1)
			"Europe/Sarajevo",//Bosnia and Herzegovina(GMT 1)
			"Europe/Skopje",//Macedonia(GMT 1)
			"Europe/Stockholm",//Sweden(GMT 1)
			"Europe/Tirane",//Albania(GMT 1)
			"Europe/Vienna",//Austria(GMT 1)
			"Europe/Zagreb",//Croatia(GMT 1)
			"Europe/Zurich",//Switzerland(GMT 1)
			"Poland",//Poland(GMT 1)
			"Europe/Paris", //Central European Time(GMT 1)
			"Europe/Minsk", //Belarus(GMT 2)
			"Africa/Gaborone", //Botswana(GMT 2)
			"Europe/Sofia", //Bulgaria(GMT 2)
			"Asia/Nicosia", //Cyprus(GMT 2)
			"Europe/Tallinn", //Estonia(GMT 2)
			"Europe/Helsinki", //Finland(GMT 2)
			"Europe/Athens", //Greece(GMT 2)
			"Asia/Amman", //Jordan(GMT 2)
			"Europe/Kaliningrad", //Kaliningrad (Russia)(GMT 2)
			"Europe/Kiev", //Kiev (Ukraine)(GMT 2)
			"Europe/Riga", //Latvia(GMT 2)
			"Asia/Beirut", //Lebanon(GMT 2)
			"Europe/Vilnius", //Lithuania(GMT 2)
			"Europe/Chisinau", //Moldova(GMT 2)
			"Asia/Gaza", //Palestinian Territory(GMT 2)
			"Europe/Bucharest", //Romania(GMT 2)
			"Europe/Simferopol", //Simferopol (Ukraine)(GMT 2)
			"Africa/Johannesburg", //South Africa(GMT 2)
			"Asia/Damascus", //Syria(GMT 2)
			"Europe/Mariehamn", //Aland Islands(GMT 2)
			"Asia/Jerusalem", //Israel(GMT 2)
			"Africa/Tripoli", //Libya(GMT 2)
			"Asia/Istanbul", //Turkey(GMT 2)
			"Africa/Cairo", //Egypt(GMT 2)
			"Asia/Baghdad", //Iraq(GMT 3)
			"Africa/Nairobi", //Kenya(GMT 3)
			"Asia/Kuwait", //Kuwait(GMT 3)
			"Europe/Moscow", //Moscow (Russia)(GMT 3)
			"Asia/Qatar", //Qatar(GMT 3)
			"Asia/Riyadh", //Saudi Arabia(GMT 3)
			"Asia/Aden", //Yemen(GMT 3)
			"Asia/Bahrain", //Bahrain(GMT 3)
			"Asia/Tehran", //Iran(GMT 3)
			"Asia/Dubai", //United Arab Emirates(GMT 4)
			"Asia/Yerevan", //Armenia(GMT 4)
			"Asia/Baku", //Azerbaijan(GMT 4)
			"Asia/Tbilisi", //Georgia(GMT 4)
			"Asia/Muscat", //Oman(GMT 4)
			"Europe/Samara", //Samara (Russia)(GMT 4)
			"Asia/Kabul", //Afghanistan(GMT 4)
			"Asia/Aqtobe", //Aqtobe (Kazakhstan)(GMT 5)
			"Asia/Katmandu", //Nepal(GMT 5)
			"Asia/Karachi", //Pakistan(GMT 5)
			"Asia/Colombo", //Sri Lanka(GMT 5)
			"Asia/Dushanbe", //Tajikistan(GMT 5)
			"Asia/Ashgabat", //Turkmenistan(GMT 5)
			"Asia/Tashkent", //Uzbekistan(GMT 5)
			"Asia/Yekaterinburg", //Yekaterinburg (Russia)(GMT 5)
			"Asia/Calcutta", //India(GMT 5)
			"Asia/Almaty", //Almaty (Kazakhstan)(GMT 6)
			"Asia/Dhaka", //Bangladesh(GMT 6)
			"Asia/Thimbu", //Bhutan(GMT 6)
			"Asia/Bishkek", //Kyrgyzstan(GMT 6)
			"Asia/Rangoon", //Myanmar(GMT 6)
			"Asia/Novosibirsk", //Novosibirsk (Russia)(GMT 6)
			"Asia/Hovd", //Hovd (Mongolia)(GMT 7)
			"Asia/Jakarta", //Jakarta (Indonesia)(GMT 7)
			"Asia/Krasnoyarsk", //Krasnoyarsk (Russia)(GMT 7)
			"Asia/Vientiane", //Laos(GMT 7)
			"Asia/Bangkok", //Thailand(GMT 7)
			"Asia/Saigon", //Vietnam(GMT 7)
			"Asia/Brunei", //Brunei(GMT 8)
			"Asia/Shanghai", //China(GMT 8)
			"Asia/Irkutsk", //Irkutsk (Russia)(GMT 8)
			"Asia/Kuching", //Kuching (Malaysia)(GMT 8)
			"Asia/Makassar", //Makassar (Indonesia)(GMT 8)
			"Asia/Kuala_Lumpur", //Malaysia(GMT 8)
			"Australia/Perth", //Perth (Australia)(GMT 8)
			"Asia/Manila", //Philippines(GMT 8)
			"Asia/Taipei", //Taiwan(GMT 8)
			"Asia/Ulaanbaatar", //Ulaanbaatar (Mongolia)(GMT 8)
			"Asia/Singapore", //Singapore(GMT 8)
			"Australia/Adelaide", //Adelaide (Australia)(GMT 9)
			"Asia/Choibalsan", //Choibalsan (Mongolia)(GMT 9)
			"Australia/Darwin", //Darwin (Australia)(GMT 9)
			"Asia/Dili", //East Timor(GMT 9)
			"Asia/Jayapura", //Jayapura (Indonesia)(GMT 9)
			"Asia/Pyongyang", //North Korea(GMT 9)
			"Asia/Seoul", //South Korea(GMT 9)
			"Asia/Yakutsk", //Yakutsk (Russia)(GMT 9)
			"Asia/Tokyo", //Japan(GMT 9)
			"Pacific/Guam", //Guam(GMT 10)
			"Australia/Hobart", //Hobart (Australia)(GMT 10)
			"Australia/Sydney", //Sydney (Australia)(GMT 10)
			"Asia/Vladivostok", //Vladivostok (Russia)(GMT 10)
			"Pacific/Yap", //Yap (Micronesia)(GMT 10)
			"Australia/Brisbane", //Brisbane (Australia)(GMT 10)
			"Asia/Magadan", //Magadan (Russia)(GMT 11)
			"Pacific/Fiji", //Fiji(GMT 12)
			"Pacific/Auckland", //New Zealand(GMT 12)
			"Pacific/Tongatapu" //Tonga(GMT 13)

    };

	String serverTimeZoneId = TimeZone.getDefault().getID();
	boolean serverIdIncluded = false;
	for (int i=0; i<timeZoneIds.length; i++) {
		if (timeZoneIds[i].equals(serverTimeZoneId)) {
			serverIdIncluded = true;
			break;
		}else if (TimeZone.getTimeZone(timeZoneIds[i]).getDisplayName(locale).equals(TimeZone.getTimeZone(serverTimeZoneId).getDisplayName(locale))) {
			timeZoneIds[i] = serverTimeZoneId;
			serverIdIncluded = true;
		}
	}
	if (!serverIdIncluded) {
		String[] newIds = new String[timeZoneIds.length+1];
		System.arraycopy(timeZoneIds, 0, newIds, 0, timeZoneIds.length);
		newIds[newIds.length-1] = serverTimeZoneId;
		timeZoneIds = newIds;
	}

	TimeZoneDisplayComparator comparator = new TimeZoneDisplayComparator();
	comparator.setLocale(locale);
	Arrays.sort(timeZoneIds, comparator);
	
	int length = timeZoneIds.length;
	String[] displayNames = new String[length];
	
	for (int i = 0; i < length; i++) {
		displayNames[i] = getDisplayName(timeZoneIds[i], locale);
	}
%>

<values>
	<%
	for (int i=0; i<timeZoneIds.length; i++) {
	%>
	<timeZone>

		<id><wcf:cdata data="<%=timeZoneIds[i]%>"/></id>
		<displayName>
			<wcf:cdata data="<%=displayNames[i]%>"/>
		</displayName>
	</timeZone>
	<%}%>
</values>