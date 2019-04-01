#include "fstream"
#include "string"
#include "fpdfsave.h"

#define EXPORT extern "C" __declspec(dllexport)
static std::ofstream g_stream;

int WriteBlock(FPDF_FILEWRITE* pFileWrite, const void* data, unsigned long size)
{
	std::string dataStr(static_cast<const char*>(data), size);
	g_stream << dataStr;

	return 1;
}

EXPORT void* NewWriter(const char* filename)
{
	FPDF_FILEWRITE* writer = new FPDF_FILEWRITE;
	writer->version = 1;
	writer->WriteBlock = WriteBlock;
	g_stream = std::ofstream(filename, std::ios::out | std::ios::binary);
	return (void*)writer;
}

EXPORT void DeleteWriter(void* ptr)
{
	if (ptr != NULL)
	{
		FPDF_FILEWRITE* writer(static_cast<FPDF_FILEWRITE*>(ptr));
		delete writer;
	}
	g_stream.close();
}
