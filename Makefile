# Development commands
.PHONY: install
install:
	uv sync --extra dev --extra lint

.PHONY: lint
lint:
	uv run flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics --exclude=.venv,build,dist
	uv run flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics --exclude=.venv,build,dist

.PHONY: build
build:
	uv run python setup.py build_ext --inplace

.PHONY: test
test:
	uv run pytest tests/ -v

.PHONY: test-basic
test-basic:
	uv run python -c "import lightfm; print('LightFM version:', lightfm.__version__); from lightfm import LightFM; from lightfm.data import Dataset; dataset = Dataset(); dataset.fit(['user1', 'user2'], ['item1', 'item2']); interactions, _ = dataset.build_interactions([('user1', 'item1'), ('user2', 'item2')]); model = LightFM(); model.fit(interactions, epochs=1, verbose=False); print('✅ Basic functionality test passed')"

.PHONY: test-all
test-all: install lint build test test-basic
	@echo "🎉 All tests passed!"

.PHONY: clean
clean:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info/
	find . -name "*.pyc" -delete
	find . -name "*.so" -delete
	find . -name "__pycache__" -type d -exec rm -rf {} +

.PHONY: build-dist
build-dist: clean
	uv run python -m build

# Original documentation commands
.PHONY: examples
examples:
	jupyter nbconvert --to rst examples/quickstart/quickstart.ipynb
	mv examples/quickstart/quickstart.rst doc/
	jupyter nbconvert --to rst examples/movielens/example.ipynb
	mv examples/movielens/example.rst doc/examples/movielens_implicit.rst
	jupyter nbconvert --to rst examples/movielens/learning_schedules.ipynb
	mv examples/movielens/learning_schedules.rst doc/examples/
	cp -r examples/movielens/learning_schedules_files doc/examples/
	rm -rf examples/movielens/learning_schedules_files
	jupyter nbconvert --to rst examples/stackexchange/hybrid_crossvalidated.ipynb
	mv examples/stackexchange/hybrid_crossvalidated.rst doc/examples/
	jupyter nbconvert --to rst examples/movielens/warp_loss.ipynb
	mv examples/movielens/warp_loss.rst doc/examples/
	cp -r examples/movielens/warp_loss_files doc/examples/
	rm -rf examples/movielens/warp_loss_files
.PHONY: update-docs
update-docs:
	pip install -e . \
	&& cd doc && make html && cd .. \
	&& git fetch origin gh-pages && git checkout gh-pages \
	&& rm -rf ./docs/ \
	&& mkdir ./docs/ \
	&& cp -r ./doc/_build/html/* ./docs/ \
	&& git add -A ./docs/* \
	&& git commit -m 'Update docs.' && git push origin gh-pages
