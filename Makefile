# Note: This is meant for Oct2Py developer use only
.PHONY: all clean test cover release gh-pages

all:
	make clean
	python setup.py install

clean:
	rm -rf build
	rm -rf dist
	find . -name "*.pyc" -o -name "*.py,cover"| xargs rm -f

test:
	make clean
	python setup.py build
	export PYTHONWARNINGS="d"; cd build; nosetests --exe -v --with-doctest
	export PYTHONWARNINGS="d"; cd build; ~/anaconda/envs/py3k/bin/nosetests --exe -v
	rm -rf build
	python setup.py check -r

cover:
	make clean
	pip install nose-cov
	nosetests --exe --with-cov --cov oct2py --cov-config .coveragerc oct2py
	coverage annotate

release:
	make clean
	pip install numpydoc
	python setup.py register
	python setup.py bdist_wheel upload
	python setup.py sdist --formats=gztar upload
	echo "Make sure to tag the branch"
	echo "Make sure to upload gh-pages"
	echo "Make sure to push to hg"

gh-pages:
	pip install sphinx-bootstrap-theme
	git checkout master
	git pull origin master
	rm -rf ../temp_docs
	mkdir ../temp_docs
	rm -rf docs/build
	make -C docs html
	cp -R docs/_build/html/ ../temp_docs
	mv ../temp_docs/html ../temp_docs/docs
	git checkout gh-pages
	rm -rf docs
	cp -R ../temp_docs/docs/ .
	git add docs
	git commit -m "rebuild docs"
	git push origin gh-pages
	rm -rf ../temp_docs
	git checkout master

