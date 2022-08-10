#!/usr/bin/env python
"""
DAFoam run script for the NASA 2D hump case
"""

# =============================================================================
# Imports
# =============================================================================
import os
import argparse
from mpi4py import MPI
from dafoam import PYDAFOAM, optFuncs
from pygeo import *
from pyspline import *
from idwarp import USMesh
from pyoptsparse import Optimization, OPT
import numpy as np


# =============================================================================
# Input Parameters
# =============================================================================
parser = argparse.ArgumentParser()
parser.add_argument("--opt", help="optimizer to use", type=str, default="ipopt")
parser.add_argument("--task", help="type of run to do", type=str, default="opt")
args = parser.parse_args()
gcomm = MPI.COMM_WORLD

# Simulation parameters

# Define the global parameters here
U0 = 1
p0 = 0.0
nuTilda0 = 1E-4
k0 = 1.0684e-07
omega0 = 10
rho = 1
dynPressure = 0.5 * rho * U0**2
J0 = 2.2839707927024846

# Set the parameters for optimization
daOptions = {
    "designSurfaces": ["b6-humpWall"],
    "solverName": "DASimpleFoam",
    "useAD": {"mode": "reverse"}, 
    "primalMinResTol": 1.0E-9,
    "objFunc": {
        "FI": {
            "velocity": {
                "type": "fieldInversion",
                "source": "boxToCell",
                "min": [-10.0, -10.0, -10.0],
                "max": [10.0, 10.0, 10.0],
                "stateType": "scalar",
                "stateName": "U",
                "stateRefName": "profileRefFieldInversion",
                "varTypeFieldInversion": "profile",
                "scale": 1,
                "addToAdjoint": True,
		        "weightedSum": True,
		        "weight": 1.0 / J0, 
            },
            "beta": {
                "type": "fieldInversion",
                "source": "boxToCell",
                "min": [-10.0, -10.0, -10.0],
                "max": [10.0, 10.0, 10.0],
                "stateType": "scalar",
                "stateName": "betaFieldInversion",
                "stateRefName": "betaRefFieldInversion",
                "varTypeFieldInversion": "volume",
                "scale": 1e-6,
                "patchNames": ["b6-humpWall"],
                "addToAdjoint": True,
                "weightedSum": False,
            },
        },
    },
    "adjStateOrdering": "cell",
    "adjEqnOption": {"gmresRelTol": 1.0E-8, "pcFillLevel": 2, "jacMatReOrdering": "natural", "gmresMaxIters":3000},
    "normalizeStates": {
        "U": U0,
        "p": U0 * U0 / 2.0,
        "k": k0,
        "omega": omega0,
        "phi": 1.0,
    },
    "adjPartDerivFDStep": {"State": 1E-7, "FFD": 1E-3},
    "adjPCLag": 100,
    "designVar": {},
    "checkMeshThreshold": {"maxAspectRatio": 25000, "maxNonOrth": 25.0, "maxSkewness": 2.5},
}

# mesh warping parameters, users need to manually specify the symmetry plane and their normals
meshOptions = {
    "gridFile": os.getcwd(),
    "fileType": "openfoam",
    # point and normal for the symmetry plane
    "symmetryPlanes": [[[0.0, 0.0, 0.0], [0.0, 0.0, 1.0]], [[0.0, 0.0, 0.1], [0.0, 0.0, 1.0]]],
}

# options for optimizers
if args.opt == "ipopt":
    optOptions = {
        "tol": 1.0E-12,
        "max_iter": 200,
        "output_file": "opt_IPOPT.out",
        "constr_viol_tol": 1.0e-12,
        "mu_strategy": "adaptive",
        "limited_memory_max_history": 26,
        "nlp_scaling_method": "gradient-based",
        "alpha_for_y": "full",
        "recalc_y": "yes",
        "print_level": 5,
        "acceptable_tol": 1.0E-12,
    }
else:
    print("opt arg not valid!")
    exit(0)


# =============================================================================
# Design variable setup
# =============================================================================
def betaFieldInversion(val, geo):
    for idxI, v in enumerate(val):
        DASolver.setFieldValue4GlobalCellI(b"betaFieldInversion", v, idxI)

DVGeo = DVGeometry("./FFD/humpFFD.xyz")
DVGeo.addRefAxis("bodyAxis", xFraction=0.25, alignIndex="k")

nCells = 44064
beta0 = np.ones(nCells, dtype="d")
#beta0[1] = 0.99
DVGeo.addGeoDVGlobal("beta", value=beta0, func=betaFieldInversion, lower=0, upper=5, scale=1)
daOptions["designVar"]["beta"] = {"designVarType": "Field", "fieldName": "betaFieldInversion", "fieldType": "scalar"}

# =============================================================================
# DAFoam initialization
# =============================================================================
DASolver = PYDAFOAM(options=daOptions, comm=gcomm)
DASolver.setDVGeo(DVGeo)
mesh = USMesh(options=meshOptions, comm=gcomm)
DASolver.addFamilyGroup(DASolver.getOption("designSurfaceFamily"), DASolver.getOption("designSurfaces"))
DASolver.printFamilyList()
DASolver.setMesh(mesh)
evalFuncs = []
DASolver.setEvalFuncs(evalFuncs)

# =============================================================================
# Constraint setup
# =============================================================================
DVCon = DVConstraints()
DVCon.setDVGeo(DVGeo)
DVCon.setSurface(DASolver.getTriangulatedMeshSurface(groupName=DASolver.getOption("designSurfaceFamily")))
# =============================================================================
# Initialize optFuncs for optimization
# =============================================================================
optFuncs.DASolver = DASolver
optFuncs.DVGeo = DVGeo
optFuncs.DVCon = DVCon
optFuncs.evalFuncs = evalFuncs
optFuncs.gcomm = gcomm

# =============================================================================
# Task
# =============================================================================
if args.task == "opt":

    optProb = Optimization("opt", objFun=optFuncs.calcObjFuncValues, comm=gcomm)
    DVGeo.addVariablesPyOpt(optProb)
    DVCon.addConstraintsPyOpt(optProb)

    optProb.addObj("FI", scale=1)
    # optProb.addCon("CL", lower=CL_target, upper=CL_target, scale=1)

    if gcomm.rank == 0:
        print(optProb)

    DASolver.runColoring()

    opt = OPT(args.opt, options=optOptions)
    histFile = "./%s_hist.hst" % args.opt
    sol = opt(optProb, sens=optFuncs.calcObjFuncSens, storeHistory=histFile)
    if gcomm.rank == 0:
        print(sol)

elif args.task == "runPrimal":

    optFuncs.runPrimal()

elif args.task == "runAdjoint":

    optFuncs.runAdjoint()

elif args.task == "verifySens":

    optFuncs.verifySens()

elif args.task == "testAPI":

    DASolver.setOption("primalMinResTol", 1e-2)
    DASolver.updateDAOption()
    optFuncs.runPrimal()

else:
    print("task arg not found!")
    exit(0)
