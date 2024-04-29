package com.ssafy.ggomalbe.bear.service;

import com.ssafy.ggomalbe.bear.entity.BingoBoard;

import java.util.LinkedList;
import java.util.Queue;

public class Bingo {
    static int[] dx = {-1,0, 1, 1};
    static int[] dy = {1, 1, 1, 0};
    static int N = 4;

    public static boolean isBingo(BingoBoard bingoBoard) {
        return bingoCheck(bingoBoard.getV());
    }

    public static boolean bingoCheck(boolean[][] boardV) {
        for (int i = 0; i <N; i++) {
            for (int j = 0; j < N; j++) {
                if(boardV[i][j] && bfs(boardV,i,j)) return true;
            }
        }
        return false;
    }

    public static boolean bfs(boolean[][] boardV, int x, int y) {
        Queue<Node> q = new LinkedList<>();
        boolean[][][] v = new boolean[4][N][N];

        for(int i =0; i<4; i++){
            q.offer(new Node(x, y, 1, i));
            v[i][x][y] = true;
        }

        while (!q.isEmpty()) {
            Node node = q.poll();
            if (node.count == N) return true;

            int nx = node.x + dx[node.dir];
            int ny = node.y + dy[node.dir];

            if (nx < 0 || ny < 0 || nx >= N || ny >= N) continue;

            if (!v[node.dir][nx][ny] && boardV[nx][ny]) {
                v[node.dir][nx][ny] = true;
                q.offer(new Node(nx, ny, node.count + 1, node.dir));
            }
        }
        return false;
    }


    static class Node {
        int x, y, count, dir;

        public Node(int x, int y, int count, int dir) {
            this.x = x;
            this.y = y;
            this.count = count;
            this.dir = dir;
        }
    }
}
