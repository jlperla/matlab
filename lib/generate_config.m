% $Rev: 1 $
% $Date: 2015-01-29 15:42:05 -0800 (Thu, 29 Jan 2015) $
% $LastChangedBy: jlperla $

% Authors: Cecilia Parlatore Siritto and Jesse Perla (c) 2010

function generate_config(template_file, params)
    try
        %Make the replacements to generate the proper module file.
        mod_file = regexprep(template_file, '.template', ''); %Gets rid of the '.template'

        %List of field names from the parameters structure
        field_names = fieldnames(params);

        %open both files
        fin = fopen(template_file);
        fout = fopen(mod_file, 'w'); %opens for writing, discarding contents if necessary

        %for each line in the file
        while ~feof(fin)
           s = fgetl(fin);
           %Replace the values in the string with the fields
            for i=1:length(field_names)
                field_name = field_names{i};
                field_value = getfield(params, field_name);
                s = strrep(s, ['%%' field_name '%%'], num2str(field_value, 16));
            end %for           
           %Output it
           fprintf(fout,'%s\n',s);
        end
        %Close the files
        fclose(fin);
        fclose(fout);
    catch E
        DispQS('Error generating config file.  Ensure it is not open in another process');
    end
end