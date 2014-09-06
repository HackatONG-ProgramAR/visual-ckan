
  $(document).ready(function()
  {
      var dominio = 'http://www.datospublicos.gob.ar/data/api/action/';
      var urls = {
          categorias_busqueda: dominio + 'group_search',
          datasets_busqueda: dominio + 'package_search',
          tags_busqueda: dominio + 'tags_search',
          categorias: dominio + 'group_list',
          datasets: dominio + 'package_list',
          tags: dominio + 'tags_list',
          categoria: dominio + 'group_show',
          dataset: dominio + 'package_show',
          tag: dominio + 'tags_show',
          busqueda:  dominio + 'datastore_search'
      };
      
      var estructura_completa = new Array();
      var total_categorias = 0;
      var actual_categorias = 0;
      
      /*
       * Callback de la llamada a la api para la obtencion de datasets
       * @param {json} data
       */
      datasetsCallback = function(data)
      {           
        if(data.success)
        {
            $('#descripcion').html('Listado de DataSets');
            var total = 0;
            $('#resultado').html('');
            for(var index in data.result){
                $('#resultado').html($('#resultado').html() 
                        + '<br>' 
                        + (total+1) 
                        + ') <a onclick="buscarDataset(\'' + data.result[index] + '\');">' + data.result[index] + '</a>'  
                );
                total ++;
            }
            $('#resultado').html($('#resultado').html() + '<br> Total: ' + total);
        }            
      };
      
      /*
       * Callback de la llamada a la api para la obtencion de categorias
       * @param {json} data
       */
      datasetCallback = function(data)
      {           
        if(data.success)
        {            
            var total = 0;
            $('#descripcion').html('Detalle de DataSet');
            $('#resultado').html('');
            for(var index in data.result)
            {                
                var tipoDato = typeof data.result[index];
                if(tipoDato == 'object'){
                    for(var index2 in data.result[index]){
                        $('#resultado').html($('#resultado').html() + '<br>' + index + ': ' + data.result[index][index2]);
                    }
                } else {
                    $('#resultado').html($('#resultado').html() + '<br>' + index + ': ' + data.result[index]);
                }                
                total ++;
            }
            $('#resultado').html($('#resultado').html() + '<br> Total: ' + total);
        }            
      };
      
      /*
       * Callback de la llamada a la api para la obtencion de categorias
       * @param {json} data
       */
      categoriaCallback = function(nombre_categoria, data)
      {           
        if(data.success)
        {
            $('#descripcion').html('Detalle categoría');
            var total = 0;
            $('#resultado').html('');
            actual_categorias ++;   
            var estructura = {
                metadatos: {},
                hijos: {}
            };
            for(var index in data.result){
                if(index == 'packages'){
                    if(data.result.package_count > 0)
                    {
                        estructura.hijos = data.result.packages;
                    }
                } else if (index !== 'package_count'){
                    estructura.metadatos[index] = data.result[index]; 
                }
            }
            estructura_completa.push(estructura);
            if(actual_categorias == total_categorias){
                alert('termino');
                
                $('#descripcion').html(JSON.stringify(estructura_completa));

            }
            /*
            for(var index in data.result){
                var tipoDato = typeof data.result[index];
                if(tipoDato == 'object'){
                    for(var index2 in data.result[index]){
                        $('#resultado').html($('#resultado').html() + '<br>' + index + ': ' + data.result[index][index2]);
                    }
                } else {
                    $('#resultado').html($('#resultado').html() + '<br>' + index + ': ' + data.result[index]);
                }               
                total ++;
            }            
            $('#resultado').html($('#resultado').html() + '<br> Total: ' + total);
            */
        }            
      };
      
      /*
       * Callback de la llamada a la api para la obtencion de categorias
       * @param {json} data
       */
      categoriasCallback = function(data)
      {           
        if(data.success)
        {
            $('#descripcion').html('Listado de categorías');
            var total = 0;
            $('#resultado').html('');
            total_categorias = data.result.length;
            for(var index in data.result)
            {
                buscarCategoria(data.result[index]);
                /*
                $('#resultado').html($('#resultado').html() 
                        + '<br>' 
                        + (total+1) 
                        + ') <a onclick="buscarCategoria(\'' + data.result[index] + '\');">' + data.result[index] + '</a>'  
                );
                total ++;
                  */
            }
            //$('#resultado').html($('#resultado').html() + '<br> Total: ' + total);
        }            
      };
      
      /*
       * Esta funcion es la encargada de realizar la peticion ajax para obtener las categorias
       */
      buscarDataset = function(dataset)
      {
        $('#descripcion').html('Buscando dataset, por favor espere');  
        $.ajax({
            url: urls.dataset,
            dataType: 'jsonp',
            data: {id: dataset},
            success: function(data) 
            {
                datasetCallback(data);
            },
            fail: function(data) 
            {
              alert('Error: ' + data.result);
            }
          });
      };
      
      /*
       * Esta funcion es la encargada de realizar la peticion ajax para obtener las categorias
       */
      buscarCategoria = function(dataset)
      {
            $('#descripcion').html('Buscando categoría, por favor espere');
            $.ajax({
                url: urls.categoria,
                dataType: 'jsonp',
                data: {id: dataset},
                success: function(data) 
                {
                    categoriaCallback(dataset, data);
                },
                fail: function(data) 
                {
                  alert('Error: ' + data.result);
                }
              });
      };
      
      /*
       * Esta funcion es la encargada de realizar la peticion ajax para obtener las categorias
       */
      buscarCategorias = function(){
        $('#categorias_menu').addClass('active');
        $('#datasets_menu').removeClass('active');
        $('#descripcion').html('Buscando categorías, por favor espere');
        $.ajax({
            url: urls.categorias,
            dataType: 'jsonp',
            //data: {variable1: 'asdsa'},
            success: function(data) 
            {
                categoriasCallback(data);
            },
            fail: function(data) 
            {
              alert('Error: ' + data.result);
            }
          });
      };
      
      /*
       * Esta funcion es la encargada de realizar la peticion ajax para obtener las categorias
       */
      buscarDataSets = function(){
        $('#categorias_menu').removeClass('active');
        $('#datasets_menu').addClass('active');
        $('#descripcion').html('Buscando datasets, por favor espere');
        $.ajax({            
            url: urls.datasets,             
            dataType: 'jsonp',
            success: function(data) 
            {
                datasetsCallback(data);
            },
            fail: function(data) 
            {
              alert('Error: ' + data.result);
            }
          });
      };
      
      //buscarCategorias();
  });