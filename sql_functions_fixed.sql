-- ============================================
-- FUNÇÕES SQL PARA O SUPABASE (VERSÃO CORRIGIDA)
-- Execute estas funções no SQL Editor do Supabase
-- ============================================

-- Primeiro, garanta que as funções estão no schema public e têm as permissões corretas

-- Função para adicionar um serviço a um cliente
CREATE OR REPLACE FUNCTION public.adicionar_cliente_servico(
  p_cliente_id TEXT,
  p_servico_id TEXT,
  p_unidade_id TEXT
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, clientes
AS $$
DECLARE
  v_result JSON;
BEGIN
  INSERT INTO clientes.clientes_servicos (
    cliente_id,
    servico_id,
    unidade_id
  ) VALUES (
    p_cliente_id::BIGINT,
    p_servico_id::BIGINT,
    p_unidade_id::BIGINT
  )
  RETURNING json_build_object(
    'id', id,
    'cliente_id', cliente_id,
    'servico_id', servico_id,
    'unidade_id', unidade_id
  ) INTO v_result;
  
  RETURN v_result;
END;
$$;

-- Conceder permissão de execução para a role anon
GRANT EXECUTE ON FUNCTION public.adicionar_cliente_servico(TEXT, TEXT, TEXT) TO anon;
GRANT EXECUTE ON FUNCTION public.adicionar_cliente_servico(TEXT, TEXT, TEXT) TO authenticated;

-- Função para atualizar um serviço atribuído
CREATE OR REPLACE FUNCTION public.atualizar_cliente_servico(
  p_atribuicao_id TEXT,
  p_servico_id TEXT,
  p_unidade_id TEXT
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, clientes
AS $$
DECLARE
  v_result JSON;
BEGIN
  UPDATE clientes.clientes_servicos
  SET 
    servico_id = p_servico_id::BIGINT,
    unidade_id = p_unidade_id::BIGINT
  WHERE id = p_atribuicao_id::BIGINT
  RETURNING json_build_object(
    'id', id,
    'cliente_id', cliente_id,
    'servico_id', servico_id,
    'unidade_id', unidade_id
  ) INTO v_result;
  
  RETURN v_result;
END;
$$;

-- Conceder permissão de execução para a role anon
GRANT EXECUTE ON FUNCTION public.atualizar_cliente_servico(TEXT, TEXT, TEXT) TO anon;
GRANT EXECUTE ON FUNCTION public.atualizar_cliente_servico(TEXT, TEXT, TEXT) TO authenticated;

-- Função para remover um serviço atribuído
CREATE OR REPLACE FUNCTION public.remover_cliente_servico(
  p_atribuicao_id TEXT
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, clientes
AS $$
DECLARE
  v_result JSON;
BEGIN
  DELETE FROM clientes.clientes_servicos
  WHERE id = p_atribuicao_id::BIGINT
  RETURNING json_build_object(
    'id', id,
    'cliente_id', cliente_id,
    'servico_id', servico_id,
    'unidade_id', unidade_id
  ) INTO v_result;
  
  RETURN v_result;
END;
$$;

-- Conceder permissão de execução para a role anon
GRANT EXECUTE ON FUNCTION public.remover_cliente_servico(TEXT) TO anon;
GRANT EXECUTE ON FUNCTION public.remover_cliente_servico(TEXT) TO authenticated;

-- ============================================
-- NOTAS IMPORTANTES:
-- 1. As funções devem estar no schema "public" para serem acessíveis via RPC
-- 2. As permissões GRANT são essenciais para permitir que a API REST chame as funções
-- 3. O SET search_path garante que a função encontre a tabela no schema "clientes"
-- ============================================
