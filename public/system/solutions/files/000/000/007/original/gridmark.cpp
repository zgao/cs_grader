/*
ID: mgao4792
TASK: gridmark
LANG: C++
 */

#include <cstdio>
#include <cstdlib>
#include <vector>
#include <algorithm>
#include <utility>

using namespace std;

FILE *fin, *fout;

int N, M;
int ans = 0;
int array[10][10];
int marked[10][10];
vector<pair<int, pair<int, int> > > pairs;

inline int value(int i, int j) {
    return array[i][j] * marked[i][j];
}

int main() {
    fin = fopen("gridmark.in", "r");
    fout = fopen("gridmark.out", "w");
    fscanf(fin, "%d%d", &N, &M);
    for (int i = 0; i < N; ++i)
        for (int j = 0; j < M; ++j) {
            fscanf(fin, "%d", &array[i][j]);
            marked[i][j] = 0;
        }
    for (int i = 0; i < N; ++i)
        for (int j = 0; j < M; ++j) {
            int sum = 0;
            if (i >= 1) sum += array[i - 1][j];
            if (i < N - 1) sum += array[i + 1][j];
            if (j >= 1) sum += array[i][j - 1];
            if (j < M - 1) sum += array[i][j + 1];
            //printf("sum %d for %d %d\n", sum, i, j);
            pairs.push_back(pair<int, pair<int, int> >(-array[i][j],
                        pair<int, int>(i, j)));
        }
    sort(pairs.begin(), pairs.end());
    for (int i = 0; i < pairs.size(); ++i) {
        int x = pairs[i].second.first, y = pairs[i].second.second;
        //printf("%d %d %d\n", x, y, pairs[i].first);
        if (x >= 1) ans += value(x - 1, y);
        if (x < N - 1) ans += value(x + 1, y);
        if (y >= 1) ans += value(x, y - 1);
        if (y < M - 1) ans += value(x, y + 1);
        marked[x][y] = 1;
    }
    fprintf(fout, "%d\n", ans);
    return 0;
}
