#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <sys/resource.h>

long max(long a,long b)
{
  return a>b?a:b;
}

double getrusageSec(){
  struct rusage t;
  struct timeval s;
  getrusage(RUSAGE_SELF, &t);
  s = t.ru_stime;
  return s.tv_sec + (double)s.tv_usec*1e-6;
}

int main(int argc, char** argv)
{
  pid_t pid;
  int status;
  FILE *fp = NULL,*result = NULL;
  struct rusage us;
  double t1,t2;
  char buf[256],B[256];
  int i;
  int mem = 0,tmem;
  int ret;
  int mle,tle;
  
  /// 新しいプロセスを作る
  /// カーネルは、同じプロセスをもう１つ作る
  t1 = getrusageSec();
  pid = fork();

  /// プロセス作成に失敗した時は、0未満を返す
  if ( pid < 0 )
  {
    fprintf (stderr, "fork error\n");
    exit(1);
  }

  /// 子プロセスのpidは、0
  if (pid == 0) 
  {
    execl(argv[1],NULL);
    exit(0);
  }
  else
  {
    if( argc <= 4 ) {
      fprintf(stderr,"./cpu exe TLE MLE result\n");
      return 0;
    }
    sscanf(argv[2],"%d",&tle);
    sscanf(argv[3],"%d",&mle);
    result = fopen(argv[4],"w");
    sprintf(buf,"/proc/%d/status",pid);
//    fprintf(stderr,"%d\n",pid);
    while( (fp = fopen(buf,"r")) ) {
      i = 11;
      while(i--) {  
fgets(B,256,fp);
if(i==9){
if(B[7]=='Z'){
goto END;
}
//fprintf(stderr,"%s %c",B,B[8]);
}
}
      fclose(fp);
      sscanf(B,"%*s%d%*s",&tmem);
      mem = max(mem,tmem);
      if( mem > mle ) {
        fprintf(result,"Error\n");
        fprintf(result,"MLE\n");
        kill(pid, SIGINT);
        exit(0);
      }
//      fprintf(stderr,"%d %s",tmem,B);
      t2 = getrusageSec();
      if( t2-t1 > tle ) {
        fprintf(result,"Error\n");
        fprintf(result,"TLE\n");
        kill(pid, SIGINT);
        exit(0);
      }
      if(tmem==0)break;
    }
END:;
    wait4(pid,&status,0,&us);
    t2 = getrusageSec();
    fprintf(result,"Safe\n");
    if (WIFEXITED(status)){
      ret = WEXITSTATUS(status);
      fprintf(result,"Exit code: %d\n", ret);
    } else if (WIFSIGNALED(status)){
      ret = WTERMSIG(status);
      fprintf(result,"Exit code: %d\n", ret);
    } else {
      fprintf(result,"Error\n");
    }
    fprintf(result,"Memory: %d kB\n",mem);
    fprintf(result,"Time: %f s\n",us.ru_utime.tv_usec*1e-6+us.ru_utime.tv_sec);
    exit(0);
  }
  return(0);
}
