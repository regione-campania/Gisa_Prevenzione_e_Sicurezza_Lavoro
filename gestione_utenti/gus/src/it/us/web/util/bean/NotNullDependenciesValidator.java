package it.us.web.util.bean;

import org.apache.commons.beanutils.BeanUtils;
import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class NotNullDependenciesValidator implements ConstraintValidator<NotNullDependencies, Object>
{
    private String[] listField;
    private boolean  allNull;

    @Override
    public void initialize(final NotNullDependencies constraintAnnotation)
    {
    	listField = constraintAnnotation.listField().split(";");
    	allNull = constraintAnnotation.allNull();
    }

    @Override
    public boolean isValid(final Object value, final ConstraintValidatorContext context)
    {
        try
        {
        	int countNull = 0;
        	
        	//Conta quanti null si sono nella lista
        	for(int i=0;i<listField.length;i++)
        	{
        		Object obj = BeanUtils.getProperty(value, listField[i]);
        		
        		if(obj==null)
        			countNull++;
        	}
        	
        	//Se non sono tutti null o tutti not-null allora la validazione di sicuro fallisce
        	if(countNull>0 && countNull<listField.length)
        		return false;
        	
        	//Se sono tutti null ma tutti null non sono ammessi allora ritorna false
        	if(countNull==listField.length && !allNull)
        		return false;
        	
        	//Se nessun test fallisce allora la lista di campi e'' valida
        	return true;
        		
        	
        }
        catch (final Exception ignore)
        {
            return false;
        }
    }
}