#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <stdio.h>

#define MAX_SIZE 66

int main(int argc, char *argv[])
{
    int serial_fd;
    ssize_t bytesRead;
    char sendBuffer[MAX_SIZE], recvBuffer[MAX_SIZE];
    struct termios ttyAttributes;

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <device>\nExample: %s /dev/pts/7\n", argv[0], argv[0]);
        exit(EXIT_FAILURE);
    }

    printf("Type a message to send to the guest:\n");
    bytesRead = read(STDIN_FILENO, sendBuffer, MAX_SIZE);
    if (bytesRead < 0) {
        perror("Error reading from stdin");
        exit(EXIT_FAILURE);
    }

    if (bytesRead == MAX_SIZE) {
        fprintf(stderr, "Error: Input exceeds 64 characters.\n");
        fflush(stdout);
        exit(EXIT_FAILURE);
    } else {
        printf("Input accepted: %zd bytes.\n", bytesRead);
    }

    /* Open the specified device */
    serial_fd = open(argv[1], O_RDWR | O_NOCTTY);
    if (serial_fd < 0) {
        perror("Failed to open the specified device");
        return EXIT_FAILURE;
    }

    /* Retrieve and modify the terminal settings */
    if (tcgetattr(serial_fd, &ttyAttributes) < 0) {
        fprintf(stderr, "Unable to get terminal attributes.\n");
        close(serial_fd);
        return EXIT_FAILURE;
    }

    /* Configure to canonical mode, 8-bit chars, local and read enabled */
    ttyAttributes.c_lflag = ICANON;
    ttyAttributes.c_cflag |= (CLOCAL | CREAD | CS8);
    ttyAttributes.c_cflag &= ~CSTOPB;

    /* Minimal input needed before returning */
    ttyAttributes.c_cc[VMIN] = 1;
    ttyAttributes.c_cc[VTIME] = 0;

    /* Set baud rate to 9600 (if applicable) */
    if (cfsetispeed(&ttyAttributes, B9600) < 0 || cfsetospeed(&ttyAttributes, B9600) < 0) {
        fprintf(stderr, "Failed to configure baud rate.\n");
        close(serial_fd);
        return EXIT_FAILURE;
    }

    /* Apply the updated settings */
    if (tcsetattr(serial_fd, TCSANOW, &ttyAttributes) < 0) {
        fprintf(stderr, "Could not apply terminal settings.\n");
        close(serial_fd);
        return EXIT_FAILURE;
    }

    /* Clear any pending data */
    tcflush(serial_fd, TCIOFLUSH);

    printf("Sending data to guest...\n");
    if (write(serial_fd, sendBuffer, MAX_SIZE) < 0) {
        perror("Error writing to device");
        close(serial_fd);
        return EXIT_FAILURE;
    }

    printf("Awaiting response from guest...\n");
    if (read(serial_fd, recvBuffer, MAX_SIZE) < 0) {
        perror("Error reading from device");
        close(serial_fd);
        return EXIT_FAILURE;
    }

    /* The protocol expects:
     * recvBuffer[0]: most frequent char
     * recvBuffer[2]: frequency of that char, as '0' + count
     */
    int frequency = recvBuffer[2] - '0';
    if (frequency > 0) {
        printf("Most frequent character: '%c' - Occurrences: %d\n", recvBuffer[0], frequency);
    } else {
        printf("No valid characters received or processed.\n");
    }

    close(serial_fd);
    return EXIT_SUCCESS;
}