from openmath.openmath import *
from scscp import SCSCPCLI

c = SCSCPCLI('localhost', 26133)
c.send(OMInteger(1))
c = SCSCPCLI('localhost', 26133)
c.heads.scscp_transient_1.MitM_Evaluate([1])

