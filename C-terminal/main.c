#include <stdio.h>
#include <Windows.h>

DWORD win32_err;
CHAR err_msg[256];

// typedef struct _DCB {
//     DWORD DCBlength;
//     DWORD BaudRate;
//     ;
//     ;
//     ;
//     BYTE ByteSize;
//     BYTE Parity;
//     BYTE StopBits;
//     char XonChar;
//     char XoffChar;
//     ;
//     WORD wReserved1;
// }DCB;

int main(void) {
    HANDLE hComm;
    hComm = CreateFileA("\\\\.\\COM5",
        GENERIC_READ | GENERIC_WRITE,
        0,
        NULL,
        OPEN_EXISTING,
        0,
        NULL);

    if(hComm == INVALID_HANDLE_VALUE) {
        printf("Error opening serial port\n");
        win32_err = GetLastError();
        FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
                        NULL,
                        win32_err,
                        0,
                        err_msg,
                        sizeof(err_msg),
                        NULL);
        printf("ERROR: %s\n", err_msg);
        return 1;
    }else
        printf("Opening serial port\n");

    DCB DCB_struct = {0};
    DCB_struct.DCBlength = sizeof(DCB_struct);
    BOOL status = GetCommState(hComm, &DCB_struct);

    if(status == FALSE)
        printf("Error in GetCommState\n");
    else
        printf("Success GetCommState\n");

    DCB_struct.BaudRate = 115200;
    DCB_struct.ByteSize = 8;
    DCB_struct.Parity = NOPARITY;
    DCB_struct.StopBits = ONESTOPBIT;
    status = SetCommState(hComm, &DCB_struct);
    if(status == FALSE)
        printf("Error in SetCommState\n");
    else
        printf("Success SetCommState\n");

    COMMTIMEOUTS timeouts = { 0 };
    timeouts.ReadIntervalTimeout         = 50;
    timeouts.ReadTotalTimeoutConstant    = 50;
    timeouts.ReadTotalTimeoutMultiplier  = 10;
    timeouts.WriteTotalTimeoutConstant   = 50;
    timeouts.WriteTotalTimeoutMultiplier = 10;

    if (SetCommTimeouts(hComm, &timeouts) == FALSE) {
        printf("Error in SetCommTimeouts\n");
    } else {
        printf("Success: Timeouts set\n");
    }

    char data_send[] = "R10";
    DWORD bytes_written = 0;

    if(WriteFile(hComm, data_send, sizeof(data_send) - 1, &bytes_written,  NULL)) {
        printf("Sent bytes\n");
    }else printf("Error to send\n");

    Sleep(100);
    char data_read[10] = {0};
    DWORD bytes_read = 0;

    if(ReadFile(hComm, data_read, sizeof(data_read) - 1, &bytes_read, NULL)) {
        if (bytes_read > 0) {
            printf("From FPGA : %s\n", data_read);
        } else {
            printf("No response from FPGA\n");
        }
    } else {
        printf("ERROR read!\n");
    }

    CloseHandle(hComm);
    return 0;
}
