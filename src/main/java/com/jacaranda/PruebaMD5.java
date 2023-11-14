package com.jacaranda;

import org.apache.commons.codec.digest.DigestUtils;

public class PruebaMD5 {

	public static void main(String[] args) {
		// TODO Auto-generated method stub

		String cadenaEncriptada = DigestUtils.md5Hex("josemi");
		System.out.println(cadenaEncriptada);
	}

}
