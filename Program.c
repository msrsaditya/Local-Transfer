#include<sys/socket.h>
#include<netinet/in.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<unistd.h>
#include<sys/mman.h>
#include<arpa/inet.h>
#define P 8192
int main(int c,char**v){
    int s,f,l,n,x,y,z;
    struct sockaddr_in a;
    char*m,b[P];
    struct stat t;
    a.sin_family = AF_INET;
    a.sin_port = htons(1337);
    a.sin_addr.s_addr = INADDR_ANY;
    s=socket(AF_INET,SOCK_STREAM,0);
    if(c>2&*v[1]=='s'){
        bind(s,(struct sockaddr*)&a,sizeof(a));
        listen(s,1);
        x=accept(s,0,0);
        f=open(v[2],O_RDONLY);
        fstat(f,&t);
        l=t.st_size;
        send(x,&l,4,0);
        m=mmap(0,l,PROT_READ,MAP_SHARED,f,0);
        for(y=0;y<l;y+=z)z=send(x,m+y,l-y>P?P:l-y,0);
        close(f);close(x);
    }else if(c>2){
        a.sin_addr.s_addr=inet_addr(v[1]);
        connect(s,(struct sockaddr*)&a,sizeof(a));
        recv(s,&l,4,0);
        f=open(v[2],O_CREAT|O_WRONLY|O_TRUNC,0644);
        for(y=0;y<l;){
            z=recv(s,b,P>l-y?l-y:P,0);
            write(f,b,z);
            y+=z;
        }
        close(f);
    }
    close(s);
}
