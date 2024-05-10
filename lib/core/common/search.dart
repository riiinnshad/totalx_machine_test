setSearchParam(String search){
 List<String> searchList=[];
 for(int i=0;i<=search.length;i++){
   for(int j=i+1;j<=search.length;j++){
     searchList.add(search.substring(i,j).toUpperCase().trim());
   }
 }
 return searchList;
}