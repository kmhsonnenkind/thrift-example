# MIT License
#
# Copyright (c) 2021 Martin Kloesch
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

'''
Setup script for example thrift service.
'''

import setuptools
try:
    from sphinx.setup_command import BuildDoc
    _cmdclass = {'build_sphinx': BuildDoc}
except ImportError:
    import warnings
    warnings.warn("'sphinx' is required to build the documentation",
                  category=ImportWarning)
    _cmdclass = {}


# Reuse README as long description
with open('README.md', 'r') as f:
    readme = f.read()


# Python installable package
setuptools.setup(
    name='calculator',
    version='0.0.1',
    description='Example thrift service for a calculator',
    long_description=readme,
    long_description_content_type='text/markdown',
    author='Martin Kloesch',
    author_email='martin.kloesch@gmail.com',
    url='https://github.com/kmhsonnenkind/thrift-example',
    packages=['calculator'],
    install_requires=[
        'thrift>=0.14'
    ],
    setup_requires=[
        'pytest-runner',
        'sphinx'
    ],
    tests_require=['pytest'],
    cmdclass=_cmdclass,
    keywords=[
        'thrift',
        'rpc',
        'example'
    ],
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Natural Language :: English',
        'Operating System :: OS Independent',
        'Programming Language :: Python :: 3.6',
        'Topic :: Software Development :: Libraries',
        'Topic :: Utilities',
        'Typing :: Typed'
    ],
    license='MIT'
)
