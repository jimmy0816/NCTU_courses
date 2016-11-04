#include <iostream>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

using namespace std;

int main(int argc, char **argv)
{
	char *server_ip = argv[1];
	int server_port = atoi(argv[2]);
	struct sockaddr_in addr;
	struct sockaddr_in cl_addr;
	int sockfd;
	int ret;


	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if(sockfd < 0){
		printf("error: creating socket.\n");
		exit(1);
	}
	
	memset(&addr, 0, sizeof(addr));  
	addr.sin_family = AF_INET;  
	addr.sin_addr.s_addr = inet_addr(server_ip);
	addr.sin_port = server_port;
	
	ret = connect(sockfd, (struct sockaddr *) &addr, sizeof(addr));  
	if (ret < 0) {  
		printf("error: connecting to the server.\n");  
		exit(1);  
	}  
	printf("%s %d\n", server_ip, server_port);
	cout<< sockfd << endl << ret << endl;

	return 0;	
}
/*
struct in_addr {
   in_addr_t   	s_addr;			// 32-bit IPv4 address, network byte order 	
};
struct sockaddr_in {
   uint8_t		sin_len;		// length of structure 
   sa_family_t	sin_family;		// AF_INET 
   in_port_t	sin_port;		// 16-bit port#, network byte order 
   struct in_addr  	sin_addr;	// 32-bit IPv4 address, network byte order 
   char 		sin_zero[8];	// unused 				
};
*/
