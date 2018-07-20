// CppStandaloneApplication.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <string>
#include <ctime>
#include <functional>
#include <assert.h>
#include <direct.h>
#include <algorithm>
#include <iostream>
#include <fstream>
#include <vector>

#import "C:\\Program Files\\Zemax OpticStudio\\ZOS-API\\Libraries\\ZOSAPII.tlb"
#import "C:\\Program Files\\Zemax OpticStudio\\ZOS-API\\Libraries\\ZOSAPI.tlb"
// Note - .tlh files will be generated from the .tlb files (above) once the project is compiled.
// Visual Studio will incorrectly continue to report IntelliSense error messages however until it is restarted.

using namespace std;
using namespace ZOSAPI;
using namespace ZOSAPI_Interfaces;

double nth_radius(int n, double focal_len, double wavlen);
void handleError(std::string msg);
void logInfo(std::string msg);
void finishStandaloneApplication(IZOSAPI_ApplicationPtr TheApplication);

int _tmain(int argc, _TCHAR* argv[])
{
	CoInitialize(NULL);

	// Create the initial connection class
	IZOSAPI_ConnectionPtr TheConnection(__uuidof(ZOSAPI_Connection));


	// Attempt to create a Standalone connection
	IZOSAPI_ApplicationPtr TheApplication = TheConnection->CreateNewApplication();
	if (TheApplication == nullptr)
	{
		handleError("An unknown error occurred!");
		return -1;
	}

	// Check the connection status
	if (!TheApplication->IsValidLicenseForAPI)
	{
		handleError("License check failed!");
		return -1;
	}
	if (TheApplication->Mode != ZOSAPI_Mode::ZOSAPI_Mode_Server)
	{
		handleError("Standlone application was started in the incorrect mode!");
		return -1;
	}

	// Argument parsing
	int ray_density = stoi(argv[1], NULL);
	double dist = _tcstod(argv[2], NULL);	// Distance from back of doublet lens to the mirror under test (mm)
	double alpha = _tcstod(argv[3], NULL);	// Angle of the test mirror surface with respect to the optic axis (deg)

	// psuedo-arguments for testing
	//double ray_density = 25;
	//double dist = 10.0;
	//double alpha = 1.0;

	// Variable declaration
	int test_mirror_ind = 7;


	// Find relative path of zemax file
	char buf[1000];
	_getcwd(buf, 1000);
	string cp(buf);
	string zp = cp + "/../zemax/TEA_GSE_design.zmx";
	//string zp = cp + "/../../../zemax/TEA_GSE_design.zmx";
	replace(zp.begin(), zp.end(), '\\', '/');
	_bstr_t model_path = _bstr_t::_bstr_t(zp.c_str());
	//_bstr_t model_path = _bstr_t::_bstr_t("../../../zemax/TEA_GSE_design.zmx");

	// Start the Zemax application
	IOpticalSystemPtr TheSystem = TheApplication->PrimarySystem;

	// Open the Zemax model file
	TheSystem->LoadFile(model_path, TRUE);

	// Open the lens data editor
	ILensDataEditorPtr lde = TheSystem->LDE;

	// Adjust test mirror parameters
	ILDERowPtr t_mirror = lde->GetSurfaceAt(test_mirror_ind);	// Get the row the mirror
	t_mirror->Thickness = dist;
	ILDERowPtr t_mirror_reflect = lde->GetSurfaceAt(test_mirror_ind + 1);
	ISurfaceCoordinateBreakPtr t_mirror_reflect_surf = t_mirror_reflect->SurfaceData;
	t_mirror_reflect_surf->TiltAbout_Y = alpha;
	

	// Create spot diagram
	long rayNumber, errorCode, vignetteCode;
	double X, Y, Z, L, M, N, l2, m2, n2, opd, intensity;
	ofstream dat_file("rays/rays.dat", ios::out | ios::binary);
	ofstream meta_file("rays/meta.dat", ios::out | ios::binary);
	vector<double> px_dat, py_dat, x_dat, y_dat;
	IBatchRayTracePtr rt = TheSystem->Tools->OpenBatchRayTrace();
	ISystemToolPtr tool = TheSystem->Tools->CurrentTool;
	IRayTraceNormUnpolDataPtr rt_dat = rt->CreateNormUnpol(1e5, RaysType_Real, lde->NumberOfSurfaces - 1);
	for (double px = -1.0; px <= 1.0; px += 2.0 / (ray_density - 1.0)) {
		for (double py = -1.0; py <= 1.0; py += 2.0 / (ray_density - 1.0)) {
			rt_dat->AddRay(0, 0.0, 0.0, px, py, OPDMode_None);
			px_dat.push_back(px);
			py_dat.push_back(py);
		}
	}
	int nr = rt_dat->NumberOfRays;
	tool->RunAndWaitForCompletion();
	rt_dat->StartReadingResults();
	for (int i = 0; i < nr; i++) {	// Read rays and save to binary file
		errorCode = 0;
		vignetteCode = 0;
		rt_dat->ReadNextResult(&rayNumber, &errorCode, &vignetteCode, &X, &Y, &Z, &L, &M, &N, &l2, &m2, &n2, &opd, &intensity);

		double vd = vignetteCode;

		dat_file.write((char*)&px_dat[i], sizeof(double));
		dat_file.write((char*)&py_dat[i], sizeof(double));
		dat_file.write((char*)&X, sizeof(double));
		dat_file.write((char*)&Y, sizeof(double));
		dat_file.write((char*)&vd, sizeof(double));
	}
	cout << nr << endl;
	meta_file.write((char*)&nr, sizeof(int));
	dat_file.close();
	meta_file.close();
	

	



	TheSystem->Save();

	TheSystem->Close(false);
			
	// Clean up
	finishStandaloneApplication(TheApplication);
	

	return 0;
}


void handleError(std::string msg)
{
	throw new exception(msg.c_str());
}

void logInfo(std::string msg)
{
	printf("%s", msg.c_str());
}

void finishStandaloneApplication(IZOSAPI_ApplicationPtr TheApplication)
{
    // Note - TheApplication will close automatically when this application exits, so this isn't strictly necessary in most cases
	if (TheApplication != nullptr)
	{
		TheApplication->CloseApplication();
	}
}


