#!/usr/bin/env python

import inspect

def list_funcs(name):
	module = __import__(name)
	ret = [ funcs[0] for funcs in  inspect.getmembers(module, inspect.isfunction)]
	return ret
