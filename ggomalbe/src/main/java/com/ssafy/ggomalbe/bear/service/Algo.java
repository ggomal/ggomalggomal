package com.ssafy.ggomalbe.bear.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Collections;
import java.util.StringTokenizer;

public class Algo {
    static StringBuilder answer = new StringBuilder();
    static int[] output;
    static boolean[] v;
    static int n,m;
    public static void main(String[] args) throws IOException {
        BufferedReader br= new BufferedReader(new InputStreamReader(System.in));
        StringTokenizer st= new StringTokenizer(br.readLine());

        n = Integer.parseInt(st.nextToken());
        m = Integer.parseInt(st.nextToken());

        output=new int[m];
        v=new boolean[n];
        perm(0);
        System.out.println(answer);
    }
    public static void perm(int depth){
        if(depth==m){
            for(int i : output) answer.append(i).append(" ");
            answer.append("\n");
            return;
        }
        for(int i = 0; i<n; i++){
            if(!v[i]){
                v[i] = true;
                output[depth] = i+1;
                perm(depth+1);
                v[i] = false;
            }
        }
    }
}