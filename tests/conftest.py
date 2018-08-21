#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Copyright 2014 Thomas Amland <thomas.amland@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
from functools import partial

import pytest

from .shell import mkdtemp, rm


@pytest.fixture(autouse=True)
def no_warnings(recwarn):
    yield
    warnings = []
    for warning in recwarn:  # pragma: no cover
        message = str(warning.message)
        # ImportWarning: Not importing directory '...' missing __init__(.py)
        if not (
            isinstance(warning.message, ImportWarning)
            and message.startswith("Not importing directory ")
            and " missing __init__" in message
        ):
            warnings.append(
                "{}:{} {}".format(warning.filename, warning.lineno, message)
            )
    assert not warnings


@pytest.fixture()
def tmpdir(request):
    path = os.path.realpath(mkdtemp())

    def finalizer():
        rm(path, recursive=True)

    request.addfinalizer(finalizer)
    return path


@pytest.fixture()
def p(tmpdir, *args):
    """
    Convenience function to join the temporary directory path
    with the provided arguments.
    """
    return partial(os.path.join, tmpdir)
