# The GAP 4 package `MathInTheMiddle'

[![Build Status](https://travis-ci.org/gap-packages/MathInTheMiddle.svg?branch=master)](https://travis-ci.org/gap-packages/MathInTheMiddle)
[![Code Coverage](https://codecov.io/github/gap-packages/MathInTheMiddle/coverage.svg?branch=master&token=)](https://codecov.io/gh/gap-packages/MathInTheMiddle)

This package provides functionality to run GAP in a Math-in-the-Middle Virtual
Research Environment for Discrete Mathematics (otherwise known as OpenDreamKit
https://www.opendreamkit.org)

## Example

A server can be created from inside GAP using the following code:

```gap
gap> LoadPackage("MathInTheMiddle");
gap> StartMitMServer();
```

To interact with the server from Python, open an interactive Python session in
another terminal by calling `python3` on the command line.  As a minimal
example, you could enter:

```python
import openmath.openmath as om, scscp
client = scscp.SCSCPCLI("localhost", 26133)
i = om.OMInteger(42)
client.heads.scscp_transient_1.MitM_Evaluate([i])
```

The output returned should be `42`.

## Documentation

Full information and documentation can be found in the manual, available
as PDF `doc/manual.pdf` or as HTML `doc/chap0_mj.html`, or on the package
homepage at

  <http://gap-packages.github.io/MathInTheMiddle/>

## Bug reports and feature requests

Please submit bug reports and feature requests via our GitHub issue tracker:

  <https://github.com/gap-packages/MathInTheMiddle/issues>


# License

MathInTheMiddle is free software; you can redistribute it and/or modify it under
the terms of the BSD 3-clause license.

For details see the files COPYRIGHT.md and LICENSE.

# Acknowledgement

<table class="none">
<tr>
<td>
  <img src="http://opendreamkit.org/public/logos/Flag_of_Europe.svg" width="128">
</td>
<td>
  This infrastructure is part of a project that has received funding from the
  European Union's Horizon 2020 research and innovation programme under grant
  agreement No 676541.
</td>
</tr>
</table>
