#include <iostream>
#include	<stdio.h>
#include	<stdlib.h>
#include	<netinet/in.h>
#include	<unistd.h>
#include	<sys/socket.h>
#include	<sys/types.h>
#include	<time.h>
#include	<string.h>
#include <arpa/inet.h>

#define BUFFER 1024
#define PORT 7777

int main(int argc, char **argv)
{
	int server_sockfd, client_sockfd;				// socketfd of server and clients
	struct sockaddr_in server_addr, client_addr;	// socket structure of server and clients
	char buffer[BUFFER];								// reply buffer
	socklen_t len_client = sizeof(client_addr);	// client length
	int ret, lsn, snd, rcv, act;						// action
	fd_set all_fds;									// master fds
	fd_set read_fds;									// readfds for select()
	fd_set write_fds;									// writefds for select()
	int fdmax;											// fds maximum
	
		
	// create server socket
	server_sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if(server_sockfd < 0){
			printf("error: creating socket\n");
			exit(1);
	}
	// initialize server socket
	bzero(&server_addr, sizeof (server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons(PORT);
	server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	
	// int bind
	ret = bind (server_sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr));
	if(ret < 0){
		printf("error: binding error\n");
		exit(1);
	}
	// int listen(sockfd,queue_len)
	lsn = listen(server_sockfd, 10);
	if(lsn < 0){
	   	printf("error: listening error\n");
	   	exit(1);
	}

	char str_server[] = "[Server] ";	
	printf("Start server!!\n\n");
	
	// clear fdsets
	FD_ZERO(&all_fds);
	FD_ZERO(&read_fds);
	FD_ZERO(&write_fds);
	
	FD_SET(server_sockfd, &all_fds);
	fdmax = server_sockfd;
	
	while(1){
		read_fds = all_fds;
		memset(buffer, 0, BUFFER);
		printf("wait select\n");
		// select(int n, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout)
		act = select(fdmax+1, &read_fds, NULL, NULL, NULL);
		if(act < 0){ printf("error: selecting error.\n"); }
		for(int i=0; i<=fdmax; i++){		// i = client fds	
			if(FD_ISSET(i, &read_fds)){
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
								if(j != server_sockfd && j != i) 	// pass server and client itself
								
								snd = send(j, buffer, strlen(buffer), 0);	// send string to client j
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
		}
		printf("123");
	}
	printf("321");
	close(server_sockfd);
	return 0;
}
