# 1brc-hs

My attempts at a Haskell solution to the [One Billion Row Challenge](https://1brc.dev/).

## Benchmarking

### V1: using `base` data structures

On my laptop, with:

```bash
hyperfine \
  -L num 1_000,10_000,100_000,1_000_000,10_000_000 \
  "./result/bin/1brc-hs measurements_{num}.txt"
```

|          rows |  runs | result (ms)        |
|--------------:|------:|:-------------------|
|         1 000 |   106 | `    33.7 ±   2.2` |
|        10 000 |    11 | `   246.6 ±   9.2` |
|       100 000 |    10 | ` 2 571   ±  23`   |
|     1 000 000 |    10 | `25 805   ± 112`   |
|    10 000 000 |     1 | `49 930`           |

### V2: using `Data.Map.Strict`

|      rows | V2.1                 |
|----------:|:---------------------|
|     1 000 | `    24.9 ±   1.9`   |
|    10 000 | `   112.6 ±   8.2`   |
|   100 000 | `   917.6 ±  28.9`   |
| 1 000 000 | `10 176   ± 412`     |

And using `Data.Text` to speed up `parseLine`:

|       rows | runs | result             |
|-----------:|-----:|:-------------------|
|      1 000 |  164 | ` 13.4  ±     0.9` |
|     10 000 |   50 | ` 52.9  ±     3.8` |
|    100 000 |   10 | `386.2  ±    10.7` |
|  1 000 000 |   10 | ` 4 107 ±    28`   |
| 10 000 000 |   10 | `47 138 ± 1 736`   |

Which is cool but, extrapolating, a billion rows would still take over an hour.

I also tried using `Data.ByteString.Char8`, but it gave very similar results as `Data.Text`:

|       rows | runs | result            |
|-----------:|-----:|:------------------|
|      1 000 |  160 | `    13.3 ±  0.4` |
|     10 000 |   60 | `    51.3 ±  5.1` |
|    100 000 |   10 | `   396.5 ±  5.6` |
|  1 000 000 |   10 | ` 4 246   ± 51`   |

But `Data.Text` has a built-in `splitOn`, so I kept that version.
