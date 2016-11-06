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
#define STDIN 0

using namespace std;

int main(int argc, char **argv)
{
	int sockfd;
	char *server_ip = argv[1];
	int server_port = atoi(argv[2]);
	struct sockaddr_in dest;
	char buffer[BUFFER];
	int ret, rcv, snd, act;
	fd_set all_fds;						// master fds
	fd_set read_fds;						// readfds for select()
	int fds[2];							// fds of stdin and client
	int fdmax;								// fds maximum

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

	// clear fdsets
	FD_ZERO(&all_fds);
	FD_ZERO(&read_fds);
	
	FD_SET(STDIN, &all_fds);
	FD_SET(sockfd, &all_fds);
	
	fds[0] = STDIN;
	fds[1] = sockfd;
	fdmax = sockfd;

	while(1){
		read_fds = all_fds;
		memset(buffer, 0, sizeof (buffer));
		/*
		// select(int n, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout)
		act = select(fdmax+1, &read_fds, NULL, NULL, NULL);
		if(act < 0){ printf("error: selecting error.\n"); }
		for(int i=0; i<2; i++){		// fds[i]
			if(i == 0){	// stdin
				if(i == server_sockfd){	// new connections
					// accept client (return client_sockfd)
					client_sockfd = accept(server_sockfd, (struct sockaddr *)&client_addr, &len_client);
					if(client_sockfd > 0){
						FD_SET(client_sockfd, &all_fds);	// add new client socket
						char str_port[10];
						sprintf(str_port, "%d", ntohs (client_addr.sin_port));
						strcpy(buffer,str_server);
						strcat(buffer,"Hello, anonymous! From: ");
						strcat(buffer,inet_ntoa(client_addr.sin_addr));
						strcat(buffer,"/");
						strcat(buffer,str_port);
						// send "Hello, anonymous....." 
						snd = send(client_sockfd, buffer, strlen(buffer), 0);
						if(snd < 0){ printf("error: sending error.\n"); }
						if(client_sockfd > fdmax)
							fdmax = client_sockfd;
						printf("New connection from: %s\n", buffer);
					}
				}
				else{ 
					// process client's command
					// receiver from client, buffer: string from client i
					rcv = recv (i, buffer, BUFFER, 0);	
					if(rcv > 0){
						printf("recv the data from the client!\nclient %d : %s", i, buffer);
						for(int j=0; j<=fdmax; j++){
							if(FD_ISSET(j, &all_fds)){
								if(j == server_sockfd && j == i) continue;	// pass server and client itself
								// send string to client j
								snd = send(j, buffer, strlen(buffer), 0);
							}
						}
					}
					else if(rcv == 0){
						printf("client %d close!\n", i);
						close(i);				// close the client
						FD_CLR(i, &all_fds);	// remove the client
					}
					else printf("What do you want ?\n");
				}
			}
		}*/
		
		// enter command
		memset(buffer, 0, sizeof (buffer));
		fgets(buffer, BUFFER, stdin);
		// only process exit command
		if(!(strncmp (buffer, "exit", 4))){
			exit(1);
		}
		// send(sockfd, buf, len, flags)
		snd = send(sockfd, buffer, strlen(buffer), 0);
		
		// receive : (sockfd, buf, len, flags)
		rcv = recv (sockfd, buffer, BUFFER, 0);
		if(rcv > 0){
			printf("%s\n", buffer);
		}

	}
	close(sockfd);
	return 0;
}
