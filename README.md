# LightFM Next

![LightFM logo](lightfm.png)

**A Python 3.12+ compatible fork of the original [LightFM](https://github.com/lyst/lightfm) recommendation library.**

| Build status | |
|---|---|
| Linux & macOS (3.8-3.12) |[![GitHub Actions](https://github.com/midodimori/lightfm-next/actions/workflows/test.yaml/badge.svg)](https://github.com/midodimori/lightfm-next/actions/workflows/test.yaml)|

[![PyPI](https://img.shields.io/pypi/v/lightfm-next.svg)](https://pypi.org/project/lightfm-next/)

> **Note**: This is a community-maintained fork that provides Python 3.12+ compatibility by fixing Cython 3.0+ build issues. All credit goes to the original [LightFM authors](https://github.com/lyst/lightfm). If you're using Python < 3.12, consider using the [original LightFM](https://github.com/lyst/lightfm) package.

LightFM is a Python implementation of a number of popular recommendation algorithms for both implicit and explicit feedback, including efficient implementation of BPR and WARP ranking losses. It's easy to use, fast (via multithreaded model estimation), and produces high quality results.

It also makes it possible to incorporate both item and user metadata into the traditional matrix factorization algorithms. It represents each user and item as the sum of the latent representations of their features, thus allowing recommendations to generalise to new items (via item features) and to new users (via user features).

For more details, see the [Documentation](http://lyst.github.io/lightfm/docs/home.html).

Need help? Contact me via [email](mailto:lightfm@zoho.com), [Twitter](https://twitter.com/Maciej_Kula), or [Gitter](https://gitter.im/lightfm-rec/Lobby).

## Installation

### For Python 3.12+
Install lightfm-next from PyPI:
```bash
pip install lightfm-next
```

> **Note**: Windows support is not available yet. Use Linux or macOS.

### For Python < 3.12
Use the original LightFM package:
```bash
pip install lightfm
```
or Conda:
```bash
conda install -c conda-forge lightfm
```

## Migration from original LightFM

lightfm-next is a **drop-in replacement** for the original LightFM. Simply replace your installation:

```bash
# Replace this
pip uninstall lightfm
pip install lightfm-next
```

**No code changes required** - all imports and APIs remain identical:
```python
from lightfm import LightFM  # Works exactly the same
```

## Quickstart
Fitting an implicit feedback model on the MovieLens 100k dataset is very easy:
```python
from lightfm import LightFM
from lightfm.datasets import fetch_movielens
from lightfm.evaluation import precision_at_k

# Load the MovieLens 100k dataset. Only five
# star ratings are treated as positive.
data = fetch_movielens(min_rating=5.0)

# Instantiate and train the model
model = LightFM(loss='warp')
model.fit(data['train'], epochs=30, num_threads=2)

# Evaluate the trained model
test_precision = precision_at_k(model, data['test'], k=5).mean()
```

## Articles and tutorials on using LightFM
1. [Learning to Rank Sketchfab Models with LightFM](http://blog.ethanrosenthal.com/2016/11/07/implicit-mf-part-2/)
2. [Metadata Embeddings for User and Item Cold-start Recommendations](http://building-babylon.net/2016/01/26/metadata-embeddings-for-user-and-item-cold-start-recommendations/)
3. [Recommendation Systems - Learn Python for Data Science](https://www.youtube.com/watch?v=9gBC9R-msAk)
4. [Using LightFM to Recommend Projects to Consultants](https://medium.com/product-at-catalant-technologies/using-lightfm-to-recommend-projects-to-consultants-44084df7321c#.gu887ky51)

## How to cite
Please cite LightFM if it helps your research. You can use the following BibTeX entry:
```
@inproceedings{DBLP:conf/recsys/Kula15,
  author    = {Maciej Kula},
  editor    = {Toine Bogers and
               Marijn Koolen},
  title     = {Metadata Embeddings for User and Item Cold-start Recommendations},
  booktitle = {Proceedings of the 2nd Workshop on New Trends on Content-Based Recommender
               Systems co-located with 9th {ACM} Conference on Recommender Systems
               (RecSys 2015), Vienna, Austria, September 16-20, 2015.},
  series    = {{CEUR} Workshop Proceedings},
  volume    = {1448},
  pages     = {14--21},
  publisher = {CEUR-WS.org},
  year      = {2015},
  url       = {http://ceur-ws.org/Vol-1448/paper4.pdf},
}
```

## Development
Pull requests are welcome. To install for development:

1. Clone the repository: `git clone https://github.com/midodimori/lightfm-next.git`
2. Install UV: `curl -LsSf https://astral.sh/uv/install.sh | sh`
3. Install dependencies: `cd lightfm-next && uv sync --extra dev --extra lint`
4. Run all tests and linting: `make test-all`

Available make commands:
- `make install` - Install dependencies and build extensions
- `make lint` - Run flake8 linting
- `make test` - Run pytest
- `make test-basic` - Run basic functionality test
- `make test-all` - Run complete test suite (same as CI)

When making changes to `.pyx` extension files, run `uv run python setup.py build_ext --inplace` to rebuild extensions.
