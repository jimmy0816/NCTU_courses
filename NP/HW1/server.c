#include<stdio.h>
#include<stdlib.h>
#include<netinet/in.h>
#include<unistd.h>
#include<sys/socket.h>
#include<sys/types.h>
#include<time.h>
#include<string.h>
#include <arpa/inet.h>

#define BUFFER 1024
#define PORT 7777

int main(int argc, char *argv[])
{
      int server_sockfd, client_sockfd;
     struct sockaddr_in server_addr, client_addr;
     char buffer[BUFFER];
     int len = sizeof (client_addr);
     int rel;
     int n;
    server_sockfd = socket (AF_INET, SOCK_STREAM, 0);
    if(server_sockfd < 0)
   {
          printf("sock error\n");
          return -1;
    }
    bzero(&server_addr, sizeof (server_addr));
    server_addr.sin_family= AF_INET;
    server_addr.sin_port= htons (PORT);
    server_addr.sin_addr.s_addr= htonl (INADDR_ANY);
    rel = bind (server_sockfd, (struct sockaddr *)&server_addr, sizeof(server_addr));
    if(rel < 0)
    {
          printf("bind error\n");
          return -1;
     }
     rel =listen (server_sockfd, 5);
     if(rel < 0)
    {
            printf("listen error\n");
            return -1;
    }
    memset(buffer, 0, BUFFER);
    while(1)
    {
          printf("wait the new client to connection!\n");
          client_sockfd= accept(server_sockfd, (struct sockaddr *)&client_addr, &len);
          if(client_sockfd > 0)
         {
                printf("server: got connection from %s, port : %d \n", inet_ntoa(client_addr.sin_addr), ntohs (client_addr.sin_port));
          }
         while(1)
        {
                memset(buffer, 0, sizeof (buffer));
                printf("please input someting what you wan to send to the client.\nserver:");
                fgets(buffer, BUFFER, stdin);
                if(!(strncmp (buffer, "quit", 4)))
                {
                      printf("server request stop!\n");
                      break;
                 }
                n =send(client_sockfd, buffer, strlen(buffer), 0);
                if(n > 0)
                {
                       printf("server send to the client success! server send %d bytes to theclient %d!\n", n);
                 }
                 else
                 {
                      printf("server send data to the client falied!\n");
                      break;
                  }
                 n =recv (client_sockfd, buffer, BUFFER, 0);
                 if(n > 0)
                {
                          printf("recv the data from the client!\nclient: %s", buffer);
                }
               else
                {
                        printf("don't recv data from client!\n");
                 }
           }
         close(client_sockfd);
    }
     close(server_sockfd);
     return 0;
}
