# pynari - Python Bindings for ANARI

This project provides a python interface for the Khronos ANARI
rendering API. This implementation currently requires a CUDA capable
GPU (support for other backends will be added at a later time).

# Usage - Quickstart

Assuming you already know how the ANARI API works, and that you have
pip-installed this package you can use ANARI in python as follows:
First, import this package:

```
import pynari as anari
```
(for all the steps below we assume you imported `pynari` as `anari`;
this is not required, but please take this in mind for the examples below).

Once the package has been imported you can then create a ANARI
"device" using

```
device = anari.newDevice('default')
```
(the 'default' will later allow to select between different back-ends, 
but is currently ignored)

You can then create various ANARI objects through creator-methods
on that device, such as, for example

```
world = device.newWorld()
mesh = device.newGeometry('triangle')
array = device.newArray(anari.FLOAT32_VEC3,vertex)
```
etc. 

# The ANARI API, and how it is exposed in `pynari`

For a full description of what ANARI Objects are, what kind of
objects exist, and how they work, please refer to the ANARI API Spec 
at https://registry.khronos.org/ANARI/specs/1.0/ANARI-1.0.html . 

Since the official ANARI API is a plain C API we could not 
implement this literally, but had to make certain changes to make ti
more "pythonic". Basically, these rules were applied (we will assume
that the `pynari` module was imported under the alias as `anari`):

- If there is a C constant/enum of name `ANARI_XYZ`, it is exposed as
  `anari.XYZ`. Example: the C enum of `ANARI_FLOAT32` is
  `anari.FLOAT32` in pynari.
  
- If there is a C API function of `anariFunctionXyz(ANARIDevice
  device, ...)` it will be exposed as `device.functionXyz(...)`. Note
  that in order to remain as close to the C-style API as possible we
  use CAML-case for function names, not python-casing. I.e., pynari
  uses `device.functionXyz(...)`, not `device.function_xyz(...)`.
  
# Examples

For a list of several samples, please visit the pynari github repo
https://github.com/ingowald/pynari

For any issues, please use the github pynari issue tracker.


