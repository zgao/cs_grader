/*
ID:mgao4792
TASK:albertgu
LANG:C++
 */

#include <cstdio>
#include <cstdlib>
#include <vector>
#include <queue>
#include <utility>
#include <algorithm>
#include <set>

#define MAXL 50000

using namespace std;

FILE *fin, *fout;
int L, B, K;
int dist[MAXL], seen[MAXL];
set<int> possible;
int a_possible[100001];
int num_possible;
int answer;
vector<pair<int, int> > graph[MAXL];
vector<pair<int, int> > search_graph[MAXL];

int test(int weight) { //returns # of "sturm chains"
    for (int i = 0; i < L; ++i) {
        dist[i] = 1000000000;
        seen[i] = 0;
        for (int j = 0; j < graph[i].size(); ++j)
            if (graph[i][j].second < weight) search_graph[i][j].second = 1;
            else search_graph[i][j].second = 0;
    }
    dist[0] = 0;
    priority_queue<pair<int, int> > Q;
    Q.push(pair<int, int>(0, 0));
    while (!Q.empty()) {
        pair<int, int> t = Q.top();
        Q.pop();
        int v1 = t.second;
        if (seen[v1]) continue;
        if (v1 == L - 1) break;
        for (int i = 0; i < search_graph[v1].size(); ++i) {
            int v = search_graph[v1][i].first;
            int d = search_graph[v1][i].second;
            if (!seen[v1] && dist[v] > dist[v1] + d) {
                dist[v] = dist[v1] + d;
                Q.push(pair<int, int>(-dist[v], v));
            }
        }
        seen[v1] = 1;
    }
    return dist[L - 1];
}

int main() {
    fin = fopen("albertgu.in", "r");
    fout = fopen("albertgu.out", "w");
    fscanf(fin, "%d%d%d", &L, &B, &K);
    for (int i = 0; i < B; ++i) {
        int tx, ty, st;
        fscanf(fin, "%d%d%d", &tx, &ty, &st);
        possible.insert(st);
        --tx; --ty;
        graph[tx].push_back(pair<int, int>(ty, st));
        graph[ty].push_back(pair<int, int>(tx, st));
        search_graph[tx].push_back(pair<int, int>(ty, 0));
        search_graph[ty].push_back(pair<int, int>(tx, 0));
    }
    for (set<int>::iterator ii = possible.begin(); ii != possible.end(); ii++)
        a_possible[num_possible++] = *ii;
    a_possible[num_possible++] = 1000000001;
    int lo = 0, hi = num_possible - 1;
    while (lo != hi) {
        int mid = (lo + hi + 1) / 2, midd = a_possible[mid];
        int num_chains = test(midd);
        if (num_chains > K) hi = mid - 1;
        else lo = mid;
        printf("%d\n", midd);
    }
    answer = a_possible[hi];
    printf("answer: %d\n", answer);
    fprintf(fout, "%d\n", (answer == 1000000001 ? 0 : answer));
    return 0;
}
