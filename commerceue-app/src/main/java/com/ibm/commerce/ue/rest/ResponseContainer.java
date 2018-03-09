package com.ibm.commerce.ue.rest;

/*
 *-----------------------------------------------------------------
 * IBM Confidential
 *
 * OCO Source Materials
 *
 * WebSphere Commerce
 *
 * (C) Copyright IBM Corp. 2015
 *
 * The source code for this program is not published or otherwise
 * divested of its trade secrets, irrespective of what has
 * been deposited with the U.S. Copyright Office.
 *-----------------------------------------------------------------
 */

import java.util.List;

/**
 * Response container class for items.
 * 
 * @param <E>
 *            The item type.
 */
public class ResponseContainer<E> {

	private List<E> items;
	private Long count;

	/**
	 * Default constructor.
	 */
	public ResponseContainer() {
		super();
	}

	/**
	 * Constructor.
	 * 
	 * @param items
	 *            The items.
	 * @param count
	 *            The count.
	 */
	public ResponseContainer(List<E> items, Long count) {
		this();
		setItems(items);
		setCount(count);
	}

	/**
	 * Returns the items.
	 * 
	 * @return The items.
	 */
	public List<E> getItems() {
		return items;
	}

	/**
	 * Sets the items.
	 * 
	 * @param items
	 *            The items.
	 */
	public void setItems(List<E> items) {
		this.items = items;
	}

	/**
	 * Returns the count.
	 * 
	 * @return The count.
	 */
	public Long getCount() {
		return count;
	}

	/**
	 * Sets the count.
	 * 
	 * @param count
	 *            The count.
	 */
	public void setCount(Long count) {
		this.count = count;
	}

	@Override
	public String toString() {
		return "ResponseContainer [items=" + items + ", count=" + count + "]";
	}

}
