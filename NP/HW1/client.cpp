#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <time.h>
#include <string.h>
#include <arpa/inet.h>

#define BUFFER 1024
#define PORT 7777

using namespace std;

int main(int argc, char **argv)
{
    int sockfd;
    char *server_ip = argv[1];
    int server_port = atoi(argv[2]);
    struct sockaddr_in dest;
    char buffer[BUFFER];
    int ret, rcv, snd;
    
    // # of argumetn must be three
    if(argc != 3){
    	exit(1);
    }
    
    // create client socket : (domain,type,protocol)
    sockfd = socket(AF_INET, SOCK_STREAM, 0);	
    if(sockfd < 0){
		printf("error: creating socket \n");
		exit(1);
    }
    
    // initialize the server structure dest 
    bzero(&dest, sizeof(dest));
    dest.sin_family= AF_INET;
    dest.sin_port= htons(server_port);			// wait know: htons
    dest.sin_addr.s_addr= inet_addr(server_ip);

	// create connetcion : (int sd, struct sockaddr *server, int addr_len)
    ret = connect(sockfd, (struct sockaddr *)&dest, sizeof(dest));
    if(ret < 0){
		printf("error: connecting error\n");
		exit(1);
    }
	printf("Connect successfully!\n");
	
    while(1){
		memset(buffer, 0, sizeof (buffer));

		// receive : (sockfd, buf, len, flags)
		rcv = recv (sockfd, buffer, BUFFER, 0);
		if(rcv > 0){
		   printf("[Server] %s\n", buffer);
		}
		
		// enter command
		memset(buffer, 0, sizeof (buffer));
		fgets(buffer, BUFFER, stdin);
		// only process exit command
		if(!(strncmp (buffer, "exit", 4))){
			exit(1);
		}
		// send(sockfd, buf, len, flags)
		snd = send(sockfd, buffer, strlen(buffer), 0);
    }
    close(sockfd);
    return 0;
}
