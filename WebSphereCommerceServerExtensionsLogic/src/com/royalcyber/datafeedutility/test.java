package com.royalcyber.datafeedutility;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class test {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		
		
		List<Map<String, String>> catalogData = new ArrayList<Map<String,String>>();
		Map<String, String> mpCMap = new HashMap<String, String>();
		mpCMap.put("1", "1");
		catalogData.add(0,mpCMap);
		mpCMap.put("2", "2");
		catalogData.add(1,mpCMap);
		System.out.println(catalogData);
		for (Map<String, String> datamap : catalogData) {
			
			System.out.println(datamap);
		}
		
		
	}

}
