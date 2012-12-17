#!/usr/bin/env python

import inspect

def list_funcs(name):
	module = __import__(name)
	return [funcs[0] for funcs in inspect.getmembers(module, inspect.isfunction)]
